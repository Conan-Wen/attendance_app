import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

// class GuestPage extends StatelessWidget {
//   const GuestPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('参加者ページ'),
//       ),
//       body: const Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[Text('参加者ページ')],
//       )),
//     );
//   }
// }


enum DeviceType { guest, host }

class GuestPage extends StatefulWidget {
  final DeviceType deviceType;
  const GuestPage(DeviceType deviceType) : this.deviceType = deviceType;

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  List<Device> devices = [
    Device('1', 'Device 1 sessionNotConnected', 0),
    Device('1', 'Device 2 sessionNotConnected', 0),
    Device('2', 'Device 3 sessionConnecting', 1),
    Device('2', 'Device 4 sessionConnecting', 1),
    Device('3', 'Device 5 sessionConnected', 2),
    Device('3', 'Device 6 sessionConnected', 2),
  ];
  List<Device> selectedDevices = [];
  late NearbyService nearbyService;
  // late StreamSubscription subscription;
  // late Streamsubscription receivedDataSubscription;

  @override
  void initState() {
    super.initState();
    
    
    // nearbyService = NearbyService();
    // subscription = nearbyService.foundDevices.listen((event) {
    //   setState(() {
    //     devices = event;
    //   });
    // });
    // receivedDataSubscription = nearbyService.receivedData.listen((event) {
    //   print(event);
    // });
  }

  @override
  void dispose() {
    // subscription.cancel();
    // receivedDataSubscription.cancel();
    // nearbyService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:  Text('ホスト一覧${selectedDevices.length}'),
      ),
      body: Container(
        child: Column(children: [
          Expanded( // ListView.builderをExpandedでラップ
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].deviceName),
                  onTap: () {
                    setState(() {
                      // selectedDevices.add(devices[index]);
                      _onTapDevice(devices[index]);
                    });
                  },
                );
              },
            ),
          ),
          // Expanded( // 2番目のListView.builderもExpandedでラップ
          //   child: ListView.builder(
          //     itemCount: selectedDevices.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(selectedDevices[index].deviceName),
          //         onTap: () {
          //           setState(() {
          //             selectedDevices.removeAt(index); // ここを修正して選択解除のロジックを追加
          //           });
          //         },
          //       );
          //     },
          //   ),
          // ),
          ElevatedButton(
            onPressed: () {
              // nearbyService.startDiscovering();
              setState(() {
                selectedDevices = []; // setStateを追加してUIの更新を保証
              });
            },
            child: const Text('再検索'),
          ),
        ],)
      ),
    );
  }
      _onTapDevice(Device device) {
        if (device.state == SessionState.connected) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            final myController = TextEditingController();
            return AlertDialog(
              title: const Text("Send message"),
              content: TextField(controller: myController),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Send"),
                  onPressed: () {
                    nearbyService.sendMessage(
                        device.deviceId, myController.text);
                    myController.text = '';
                  },
                )
              ],
            );
          });
    }
  }
  
}
      
        
      
      
      //  ListView.builder(
      //   itemCount: devices.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(devices[index].deviceName),
      //       onTap: () {
      //         setState(() {
      //           selectedDevices.add(devices[index]);
      //         });
      //       },
      //     );
      //   },
      // ),
      
//     );
//   }
// }




// enum DeviceType {
//   guest,
//   host,
// }

// class GuestPage extends StatelessWidget {
//   List<Device> devices = [];
//   List<Device> selectedDevices = [];

//   GuestPage({super.key});
//   // late NearbyService nearbyService;
//   // late StreamSubscription subscription;
//   // late Streamsubscription receivedDataSubscription;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('ホスト一覧'),
//       ),
//       body: ListView.builder(
//         itemCount: devices.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(devices[index].deviceName),
//             onTap: () => selectedDevices.add(devices[index]),
//             },
//           );
//         },
//       ),
//     );
//   }

//   // List<String> get devices {
//   //   // ここにデバイスのリストを返すコードを追加してください
//   //   return [
//   //     'Device 1',
//   //     'Device 2',
//   //     'Device 3',
//   //     // 他のデバイスを追加する場合は、ここに追加してください
//   //   ];
//   // }
  

//   }
// }



// children: <Widget>[
      //     ElevatedButton(
      //       onPressed: () {
      //         // nearbyService.startDiscovering();
      //       },
      //       child: const Text('検索開始'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         // nearbyService.stopDiscovering();
      //       },
      //       child: const Text('検索停止'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         // nearbyService.connect(selectedDevices[0]);
      //       },
      //       child: const Text('接続'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         // nearbyService.sendData('Hello');
      //       },
      //       child: const Text('データ送信'),
      //     ),
      //   ],
      // )