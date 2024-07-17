import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class HostPage extends StatefulWidget {
  final String conferenceName;
  final List<String> participants;

  const HostPage({super.key, required this.conferenceName, required this.participants});

  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  IconData statusIcon = Icons.check_circle;
  Color iconColor = Colors.green;
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  void _changeStatusIcon(index) {
    setState(() {
      if (statusIcon == Icons.highlight_off) {
        statusIcon = Icons.check_circle_outline;
        iconColor = Colors.green;
      } else {
        statusIcon = Icons.highlight_off;
        iconColor = Colors.red;
      }
    });
  }

  void _registerAttendance(name,deviceId ) {
    // 出席登録の処理
    // nameのstringがconferenceNameの中に含まれているか確認してインデックスを抽出
    // participantsのインデックスを抽出して、そのインデックスのstatusIconを変更する
      // nameがconferenceNameの中に含まれているか確認してインデックスを抽出
    
    // final myController = TextEditingController();
    int index = widget.conferenceName.indexOf(name);
    _changeStatusIcon(index);
    // // 出席完了メッセージを送信
    nearbyService.sendMessage(
      deviceId,
      "出席完了"
    );
    // // 接続を切る
    nearbyService.disconnectPeer(deviceID: deviceId);
}

void _aggregateAttendanceData(){
  setState(() {
    //出席情報集計処理
    // bluetooth待ち解除
    // nearbyService.stopAdvertisingPeer();
    //集計結果画面遷移？？
  });
}

  @override
  void initState() {
    super.initState();
    init();
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
                  leading: Icon(statusIcon, color: iconColor),
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
        deviceName: devInfo,
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

        if (Platform.isAndroid) {
          if (element.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
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
      // data["message"]（氏名）を取り出して出席確認の処理に入る
      _registerAttendance(data["message"],data["deviceId"]);
    });
  }
}

