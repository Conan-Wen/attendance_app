import 'package:attendance_app/HostPage/attendance_result.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/HostPage/Database.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class HostPage extends StatefulWidget {
  final int id;
  final String conferenceName;
  final List<String> participants;
  final int closed = 0;

  const HostPage(
      {super.key,
      required this.id,
      required this.conferenceName,
      required this.participants});

  @override
  HostPageState createState() => HostPageState();
}

class HostPageState extends State<HostPage> {
  IconData statusIcon = Icons.check_circle;
  Color iconColor = Colors.green;
  late List<bool> checkList;
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  IconData getStatusIcon(bool check) {
    return check ? Icons.check_circle_outline : Icons.highlight_off;
  }

  Color getColorIcon(bool check) {
    return check ? Colors.green : Colors.red;
  }

  void _registerAttendance(name, deviceId) {
    // 出席登録の処理
    setState(() {
      String response = "出席者リストに存在しません";
      for (int i = 0; i < widget.participants.length; i++) {
        if (widget.participants[i] == name) {
          response = checkList[i] ? "出席登録済み" : "出席登録完了";
          //未出席だった人の処理
          if (!checkList[i]) {
            checkList[i] = true;
            break;
          }
        }
      }
      nearbyService.sendMessage(deviceId, response);
      nearbyService.disconnectPeer(deviceID: deviceId);
    });
  }

  void _aggregateAttendanceData() {
    setState(() {
      //出席情報集計処理

      // bluetooth待ち解除
      nearbyService.stopAdvertisingPeer();
      nearbyService.startBrowsingForPeers();
      //集計結果画面遷移？？
      DatabaseHelper().updateMeeting(Meeting(
          id: widget.id,
          meetingName: widget.conferenceName,
          participants: widget.participants));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AttendanceResultScreen(
                  participants: widget.participants,
                  checkList: checkList,
                  conferenceName: widget.conferenceName)));
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    checkList = List<bool>.filled(widget.participants.length, false);
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.conferenceName,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.participants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(getStatusIcon(checkList[index]),
                      color: getColorIcon(checkList[index])),
                  title: Text(widget.participants[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _aggregateAttendanceData,
              child: const Text('締め切り'),
            ),
          ),
        ],
      ),
    );
  }

  void init() async {
    nearbyService = NearbyService();
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: widget.conferenceName,
        strategy: Strategy.P2P_STAR, // 1-to-N
        callback: (isRunning) async {
          if (isRunning) {
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            await Future.delayed(const Duration(microseconds: 200));
            await nearbyService.startAdvertisingPeer();
            await nearbyService.startBrowsingForPeers();
            // }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
      for (var element in devicesList) {
        print(
            " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");
      }
    });

    // メッセージ（氏名）を受け取った場合の処理
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
      print("dataReceivedSubscription: ${jsonEncode(data)}");
      _registerAttendance(data["message"], data["senderDeviceId"]);
    });
  }
}
