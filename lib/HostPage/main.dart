import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class HostPage extends StatefulWidget {
  final DeviceType deviceType;
  final String conferenceName;
  final List<String> participants;

  const HostPage({super.key, required this.deviceType, required this.conferenceName, required this.participants});

  @override
  _HostPageState createState() => _HostPageState();
}

enum DeviceType { advertiser, browser }

class _HostPageState extends State<HostPage> {
  IconData statusIcon = Icons.check_circle;
  Color iconColor = Colors.green;
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  void _changeStatusIcon() {
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

  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  void dispose() {
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
              onPressed: _changeStatusIcon,
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
            if (widget.deviceType == DeviceType.browser) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
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

    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
      print("dataReceivedSubscription: ${jsonEncode(data)}");
      showToast(jsonEncode(data),
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom);
    });
  }
}

