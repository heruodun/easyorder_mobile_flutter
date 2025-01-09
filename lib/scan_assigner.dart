import 'package:easyorder_mobile/order_task.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:flutter/material.dart';

// 分单
class ScanAssignerScreen extends ScanScreenStateful {
  const ScanAssignerScreen({
    super.key,
  });

  @override
  _ScanAssignerState createState() => _ScanAssignerState();
}

class _ScanAssignerState extends ScanScreenState<ScanAssignerScreen> {
  @override
  Widget build(BuildContext context) {
    String appBarStr = "分单扫码";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarStr),
      ),
      body: super.buildScanScreen(context),
    );
  }

  @override
  void doProcess(String result) async {
    RegExp pattern = RegExp(r'\d+');
    RegExpMatch? match = pattern.firstMatch(result);

    String? orderIdStr = match?.group(0);
    if (orderIdStr == null) {
      //异常了
      return;
    }

    _navigateToScreen(result);
  }

  void _navigateToScreen(String orderIdQr) {
    controller.stop(); // 暂停扫描
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderPage(
                orderIdQr: orderIdQr,
              )),
    ).then((_) {
      // 当从ScreenX返回时，这里的代码被执行
      if (mounted) {
        // controller.start(); // 恢复扫描
      }
    });
  }

  @override
  bool canProcess(String currentLabel) {
    return currentLabel == "分单";
  }
}
