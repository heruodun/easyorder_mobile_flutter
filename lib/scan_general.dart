import 'dart:async';
import 'package:easyorder_mobile/home2.dart';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/user_role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:vibration/vibration.dart';

// 通用
class ScanGeneralScreen extends ScanScreenStateful {
  const ScanGeneralScreen({super.key}) : super();

  @override
  ScanGeneralState createState() => ScanGeneralState();
}

class ScanGeneralState extends ScanScreenState<ScanGeneralScreen> {
  late Role role;
  @override
  Widget build(BuildContext context) {
    // BottomNavigationBarProvider provider =
    //     Provider.of<BottomNavigationBarProvider>(context, listen: false);

    role = Provider.of<RoleManager>(context, listen: false).role;
    String operation = role.roleName;

    String appBarStr = "$operation扫码";

    return super.buildScanScreen(context);
  }

  @override
  void doProcess(String result) async {
    String operation = role.roleName;
    String operationCode = role.roleCode;

    RegExp pattern = RegExp(r'\d+');
    RegExpMatch? match = pattern.firstMatch(result);

    String? orderIdStr = match?.group(0);
    if (orderIdStr == null) {
      //异常了
      return;
    }

    int orderId = int.parse(orderIdStr);

    bool hasProcessed = await isProcessed(operationCode, orderId);

    if (hasProcessed) {
      super.scanResultText = "已$operation扫码\n$orderId";
      super.scanResultColor = Colors.yellow;
    } else {
      try {
        var response = await httpClient(
          uri: Uri.parse('$httpHost/app/order/scan'),
          body: {
            'orderIdQr': result,
            'operation': operationCode,
          },
          method: 'POST',
        );
        if (response.isSuccess) {
          Vibration.vibrate();
          setState(() {
            super.scanResultText = "$operation扫码成功\n$orderId";
            super.scanResultColor = Colors.green;
          });
          setProcessed(operationCode, orderId);
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

  Future<bool> isProcessed(String operationCode, int orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operationCode, orderId);
    int? lastTimestamp = prefs.getInt(key);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    if (lastTimestamp == null ||
        (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
      return false;
    }
    return true;
  }

  void setProcessed(String operationCode, int orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operationCode, orderId);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(key, currentTimeMillis);
  }

  String _makeScanKey(String operationCode, int orderId) {
    String key = 'prefix$operationCode$orderId';
    return key;
  }

  @override
  bool canProcess(String currentLabel) {
    return true;
    // return currentLabel == role.roleName;
  }
}
