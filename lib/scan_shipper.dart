import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/wave_detail_shipper.dart';
import 'package:flutter/material.dart';
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

    try {
      final response = await httpClient(
          uri: Uri.parse('$httpHost/app/order/wave/queryByOrder/$result'),
          method: "GET",
          context: context);

      if (response.isSuccess) {
        Wave wave = Wave.fromJson(response.data);
        //  setProcessed(orderId);
        _navigateToScreen(wave);
      } else {
        String msg = response.message;
        setState(() {
          super.scanResultText = "$msg\n$result";
          super.scanResultColor = Colors.red;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        super.scanResultText = "扫码异常\n$result";
        super.scanResultColor = Colors.red;
      });
    }
  }

  @override
  bool canProcess(String currentLabel) {
    return currentLabel == "送货";
  }
}
