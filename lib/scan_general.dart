import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/user_role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar.dart';
import 'constants.dart';
import 'package:vibration/vibration.dart';

// 通用
class ScanGeneralScreen extends ScanScreenStateful {
  final Role role;
  const ScanGeneralScreen({super.key, required this.role}) : super();

  @override
  ScanGeneralState createState() => ScanGeneralState();
}

class ScanGeneralState extends ScanScreenState<ScanGeneralScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<BottomNavigationBarProvider>(context, listen: false);

    String operation = widget.role.roleName;

    String appBarStr = "$operation扫码";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarStr),
      ),
      body: super.buildScanScreen(context),
    );
  }

  @override
  void doProcess(String result) async {
    final Role role = widget.role;
    String operation = role.roleName;
    String operationCode = role.roleCode;

    bool hasProcessed = await isProcessed(operationCode, result);

    if (hasProcessed) {
      super.scanResultText = "已$operation扫码\n$result";
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
            context: context);
        if (response.isSuccess) {
          Vibration.vibrate();

          setState(() {
            super.scanResultText = "$operation扫码成功\n$result";
            super.scanResultColor = Colors.green;
          });
          setProcessed(operationCode, result);
        } else {
          String msg = response.message;
          setState(() {
            super.scanResultText = "$msg\n$result";
            super.scanResultColor = Colors.red;
          });
        }
      } catch (e) {
        setState(() {
          super.scanResultText = "扫码异常\n$result";
          super.scanResultColor = Colors.red;
        });
      }
    }
  }

  @override
  bool canProcess(String currentLabel) {
    return currentLabel == widget.role.roleName;
  }
}
