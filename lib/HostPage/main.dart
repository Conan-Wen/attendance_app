import 'package:attendance_app/HostPage/attendance_result.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class HostPage extends StatefulWidget {
  final String conferenceName;
  final List<String> participants;

  const HostPage(
      {super.key, required this.conferenceName, required this.participants});

  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  IconData statusIcon = Icons.check_circle;
  Color iconColor = Colors.green;
  late List<bool> checkList;
  List<Device> devices = [];
  List<Device> connectedDevices = [];
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
      for (int i = 0; i < widget.participants.length; i++) {
        if (widget.participants[i] == name && !checkList[i]) {
          checkList[i] = true;
          nearbyService.sendMessage(deviceId, "出席登録完了");
          break;
        }
        else if (widget.participants[i] == name && checkList[i]) {
          nearbyService.sendMessage(deviceId, "出席登録済み");
          break;
        } 
        else if (i == widget.participants.length - 1) {
          nearbyService.sendMessage(deviceId, "出席者リストに存在しません");
        }
      }
      nearbyService.disconnectPeer(deviceID: deviceId);
    });
  }

  void _aggregateAttendanceData() {
    setState(() {
      //出席情報集計処理
    
      // bluetooth待ち解除
      nearbyService.stopAdvertisingPeer(); 
      nearbyService.startBrowsingForPeers();
      connectedDevices.clear();
      //集計結果画面遷移？？
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AttendanceResultScreen(participants:widget.participants, checkList:checkList, conferenceName:widget.conferenceName)
        )
      );
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
        title: Text(widget.conferenceName),
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
    String devInfo = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: widget.conferenceName,
        strategy: Strategy.P2P_STAR, // 1-to-N
        callback: (isRunning) async {
          if (isRunning) {
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            await Future.delayed(Duration(microseconds: 200));
            await nearbyService.startAdvertisingPeer();
            await nearbyService.startBrowsingForPeers();
            // }
          }
        });
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) {
      devicesList.forEach((element) {
        print(
            " deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");
      });

      setState(() {
        devices.clear();
        devices.addAll(devicesList);
        connectedDevices.clear();
        connectedDevices.addAll(devicesList
            .where((d) => d.state == SessionState.connected)
            .toList());
      });
    });

    // メッセージ（氏名）を受け取った場合の処理
    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
      print("dataReceivedSubscription: ${jsonEncode(data)}");
      String participantName = data["message"];
      _registerAttendance(participantName, data["senderDeviceId"]);
    });
  }
}