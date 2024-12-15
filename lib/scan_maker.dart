import 'dart:async';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'user_data.dart';
import 'package:vibration/vibration.dart';

// 做货
class ScanMakerScreen extends ScanScreenStateful {
  const ScanMakerScreen({
    super.key,
  });

  @override
  _ScanMakerState createState() => _ScanMakerState();
}

class _ScanMakerState extends ScanScreenState<ScanMakerScreen> {
  @override
  Widget build(BuildContext context) {
    String appBarStr = "对接扫码";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarStr),
      ),
      body: super.buildScanScreen(context),
    );
  }

  @override
  void doProcess(String result) async {
    print(" maker doProcess------------------");

    RegExp pattern = RegExp(r'\d+');
    RegExpMatch? match = pattern.firstMatch(result);

    String? orderIdStr = match?.group(0);
    if (orderIdStr == null) {
      //异常了
      return;
    }

    int orderId = int.parse(orderIdStr);

    bool hasProcessed = await isProcessed(orderId);

    if (hasProcessed) {
      super.scanResultText = "已对接扫码\n$orderId";
      super.scanResultColor = Colors.yellow;
    } else {
      try {
        var response = await httpClient(
          uri: Uri.parse('$httpHost/app/order/scan'),
          body: {
            'orderIdQr': result,
            'operation': duijieRoleCode,
          },
          method: 'POST',
        );
        if (response.isSuccess) {
          Vibration.vibrate();
          setState(() {
            super.scanResultText = "对接扫码成功\n$orderId";
            super.scanResultColor = Colors.blue;
          });
          setProcessed(orderId);
        } else {
          String msg = response.message;
          setState(() {
            super.scanResultText = "$msg\n$orderId";
            super.scanResultColor = Colors.red;
          });
        }
      } catch (e) {
        setState(() {
          super.scanResultText = "扫码异常\n$orderId";
          super.scanResultColor = Colors.red;
        });
      }
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
    return '$prefix4maker$orderId';
  }

  @override
  bool canProcess(String currentLabel) {
    return currentLabel == "对接";
  }
}
