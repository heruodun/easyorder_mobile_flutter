import 'dart:async';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/wave_detail_shipper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'login.dart';
import 'wave_data.dart';

// 送货
class ScanShipperScreen extends ScanScreenStateful {
  const ScanShipperScreen({super.key});

  @override
  ScanShipperState createState() => ScanShipperState();
}

class ScanShipperState extends ScanScreenState<ScanShipperScreen> {
  @override
  Widget build(BuildContext context) {
    String appBarStr = "送货扫码";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarStr),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('登出'),
              ),
            ],
          )
        ],
      ),
      body: super.buildScanScreen(context),
    );
  }

  // 处理PopupMenuButton选项的选中事件
  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        logout(context);
        break;
      // 其他case...
    }
  }

  void _navigateToScreen(Wave wave) {
    controller.stop(); // 暂停扫描
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WaveDetailsShipperScreen(
                wave: wave,
              )),
    ).then((_) {
      // 当从ScreenX返回时，这里的代码被执行
      if (mounted) {
        controller.start(); // 恢复扫描
      }
    });
  }

  @override
  void doProcess(String result) async {
    print(" shipper doProcess------------------");

    RegExp pattern = RegExp(r'\d+');
    RegExpMatch? match = pattern.firstMatch(result);

    String? orderIdStr = match?.group(0);
    if (orderIdStr == null) {
      //异常了
      return;
    }

    int orderId = int.parse(orderIdStr);

    try {
      final response = await httpClient(
          uri: Uri.parse('$httpHost/app/order/wave/queryByOrder/$result'),
          method: "GET");

      if (response.isSuccess) {
        Wave wave = Wave.fromJson(response.data);
        //  setProcessed(orderId);
        _navigateToScreen(wave);
      } else {
        String msg = response.message;
        setState(() {
          super.scanResultText = "$msg\n$orderId";
          super.scanResultColor = Colors.red;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        super.scanResultText = "扫码异常\n$orderId";
        super.scanResultColor = Colors.red;
      });
    }
  }

  @override
  bool canProcess(String currentLabel) {
    return currentLabel == "送货";
  }
}

Future<bool> isProcessed(int orderId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = _makeScanKey(orderId);
  int? lastTimestamp = prefs.getInt(key);
  int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
  if (lastTimestamp == null ||
      (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
    return false;
  }
  return true;
}

void setProcessed(int orderId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String key = _makeScanKey(orderId);
  int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
  prefs.setInt(key, currentTimeMillis);
}

String _makeScanKey(int orderId) {
  return '$prefix4shipper$orderId';
}
