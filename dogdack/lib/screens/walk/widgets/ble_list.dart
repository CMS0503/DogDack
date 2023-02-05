import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../controller/walk_controller.dart';

class BleList extends StatefulWidget {
  BleList({Key? key}) : super(key: key);

  // 장치 정보 전달 받기
  late BluetoothDevice device;
  // final String serviceUuid = '0000ffe0-0000-1000-8000-00805f9b34fb';
  // final String characteristicUuid = '0000ffe1-0000-1000-8000-00805f9b34fb';
  // late String receiveData = '';
  // Map? location;
  bool isConnected = false;

  @override
  State<BleList> createState() => _BleState();
}

class _BleState extends State<BleList> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult> scanResultList = [];
  int scanMode = 2;
  bool _isScanning = false;
  List connectedDevices = [];
  final walkController = Get.put(WalkController());

  // 연결 상태 표시 문자열
  String stateText = 'Connecting';

  // 연결 버튼 문자열
  String connectButtonText = 'Disconnect';

  // 현재 연결 상태 저장용
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  // 연결 상태 리스너 핸들 화면 종료시 리스너 해제를 위함
  StreamSubscription<BluetoothDeviceState>? _stateListener;

  List<BluetoothService> bluetoothService = [];

  //
  Map<String, String> notifyDatas = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 상태 리스터 해제
    _stateListener?.cancel();
    // 연결 해제
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      // 화면이 mounted 되었을때만 업데이트 되게 함
      super.setState(fn);
    }
  }

  void initBle() {
    flutterBlue.isScanning.listen((isScanning) {
      _isScanning = isScanning;
      setState(() {});
    });
  }

  setBleConnectionState(BluetoothDeviceState event) {
    switch (event) {
      case BluetoothDeviceState.disconnected:
        stateText = 'Disconnected';
        // 버튼 상태 변경
        connectButtonText = 'Connect';
        break;
      case BluetoothDeviceState.disconnecting:
        stateText = 'Disconnecting';
        break;
      case BluetoothDeviceState.connected:
        stateText = 'Connected';
        // 버튼 상태 변경
        connectButtonText = 'Disconnect';
        break;
      case BluetoothDeviceState.connecting:
        stateText = 'Connecting';
        break;
    }
    //이전 상태 이벤트 저장
    deviceState = event;
    setState(() {});
  }

  Future<bool> connect(ScanResult r) async {
    Future<bool>? returnValue;
    setState(() {
      /* 상태 표시를 Connecting으로 변경 */
      stateText = 'Connecting';
    });
    flutterBlue.stopScan();
    /*
      타임아웃을 15초(15000ms)로 설정 및 autoconnect 해제
       참고로 autoconnect가 true되어있으면 연결이 지연되는 경우가 있음.
     */

    widget.device = r.device;

    _stateListener = widget.device.state.listen((event) {
      debugPrint('event :  $event');
      if (deviceState == event) {
        // 상태가 동일하다면 무시
        return;
      }
      // 연결 상태 정보 변경
      setBleConnectionState(event);
    });

    await widget.device
        .connect(autoConnect: false)
        .timeout(Duration(milliseconds: 15000), onTimeout: () {
      //타임아웃 발생
      //returnValue를 false로 설정
      returnValue = Future.value(false);
      debugPrint('timeout failed');

      //연결 상태 disconnected로 변경
      setState(() {});
      setBleConnectionState(BluetoothDeviceState.disconnected);
    }).then((data) async {
      connectedDevices = await flutterBlue.connectedDevices;

      bluetoothService.clear();
      if (returnValue == null) {
        //returnValue가 null이면 timeout이 발생한 것이 아니므로 연결 성공
        debugPrint('connection successful');
        print('start discover service');

        walkController.services = await widget.device.discoverServices();
        walkController.connectBle(r.device);
        print('end discovor service');
        returnValue = Future.value(true);
      }
    });

    return returnValue ?? Future.value(false);
  }

  void disconnect() {
    try {
      walkController.device!.disconnect();
    } catch (e) {}
  }

  void toggleState() {
    _isScanning = !_isScanning;

    if (_isScanning) {
      flutterBlue.startScan(
          scanMode: ScanMode(scanMode), allowDuplicates: true);
      scan();
    } else {
      flutterBlue.stopScan();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void scan() async {
    if (_isScanning) {
      flutterBlue.scanResults.listen((results) {
        scanResultList = results;
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Widget connectButton(ScanResult r) {
    bool isConnected = (connectedDevices.isNotEmpty &&
            connectedDevices
                .where((element) => element.id == r.device.id)
                .isNotEmpty)
        ? true
        : false;
    return isConnected
        ? Container(
            width: 100,
            height: 28,
            child: OutlinedButton(
              child: Text('disconnect'),
              onPressed: () => disconnect(),
            ),
          )
        : Container(
            width: 85,
            height: 28,
            child: OutlinedButton(
              child: Text('Connect'),
              onPressed: () => {connect(r), setState(() {})},
            ),
          );
  }

  /* 장치의 MAC 주소 위젯  */
  Widget deviceMacAddress(ScanResult r) {
    return Text(r.device.id.id);
  }

  /* 장치의 명 위젯  */
  Widget deviceName(ScanResult r) {
    String name;

    if (r.device.name.isNotEmpty) {
      // device.name에 값이 있다면
      name = r.device.name;
    } else if (r.advertisementData.localName.isNotEmpty) {
      // advertisementData.localName에 값이 있다면
      name = r.advertisementData.localName;
    } else {
      // 둘다 없다면 이름 알 수 없음...
      name = 'N/A';
    }
    return Text(name);
  }

  /* BLE 아이콘 위젯 */
  Widget leading(ScanResult r) {
    return const CircleAvatar(
      backgroundColor: Colors.cyan,
      child: Icon(
        Icons.bluetooth,
        color: Colors.white,
      ),
    );
  }

  /* 장치 아이템을 탭 했을때 호출 되는 함수 */
  void onTap(ScanResult r) async {
    // 단순히 이름만 출력
    print('This device is ${r.device.name}');
  }

  /* 장치 아이템 위젯 */
  Widget listItem(ScanResult r) {
    if (r.device.name.isNotEmpty) {
      return Column(
        children: <Widget>[
          ListTile(
            onTap: () => onTap(r),
            leading: leading(r),
            title: deviceName(r),
            subtitle: deviceMacAddress(r),
            trailing: connectButton(r),
          ),
          Divider()
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BleList'),
      ),
      body: Center(
        /* 장치 리스트 출력 */
        child: ListView.builder(
          itemCount: scanResultList.length,
          itemBuilder: (context, index) {
            return listItem(scanResultList[index]);
          },
        ),
      ),
      /* 장치 검색 or 검색 중지  */
      floatingActionButton: FloatingActionButton(
        onPressed: toggleState,
        // 스캔 중이라면 stop 아이콘을, 정지상태라면 search 아이콘으로 표시
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
