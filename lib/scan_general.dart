

import 'dart:async';
import 'dart:convert';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_nav_bar.dart';
import 'constants.dart';
import 'user_data.dart';
import 'package:vibration/vibration.dart';



// 通用
class ScanCheckerScreen extends ScanScreenStateful {

  const ScanCheckerScreen({super.key}) : super();
  
  @override
  ScanCheckerState createState() => ScanCheckerState();
}

class ScanCheckerState extends ScanScreenState<ScanCheckerScreen> {

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<BottomNavigationBarProvider>(context, listen: false);

    String operation = provider.currentLabel;

    String appBarStr = "$operation扫码";
    

    return Scaffold(
      appBar: AppBar(
        title:  Text(appBarStr),
      ),
      body: 
          super.buildScanScreen(context),
    );
  }

 

  @override
  void doProcess(String result) async {

    final provider = Provider.of<BottomNavigationBarProvider>(context, listen: false);

    String operation = provider.currentLabel;
     
    print(" checker doProcess------------------");
      RegExp pattern = RegExp(r'\d+');
      RegExpMatch? match = pattern.firstMatch(result);

      String? orderIdStr = match?.group(0);
      if(orderIdStr == null){
        //异常了
        return;
      }

      int orderId = int.parse(orderIdStr);

      bool hasProcessed =  await isProcessed(operation, orderId);

      if(hasProcessed){
        super.scanResultText = "已$operation扫码\n$orderId";
        super.scanResultColor = Colors.yellow;
      }
      else{

        User? user = await User.getCurrentUser(); 

        try {

            var response = await httpClient(
            uri: Uri.parse('$httpHost/mobile/order/scan'),
            
            body: {
              'orderId': orderId,
              'operator': user!.actualName,
              'operationStr': operation,
            },
            method: 'POST',
          );
          if (response.isSuccess) {
            Vibration.vibrate();
             setState(() {
              super.scanResultText = "$operation扫码成功\n$orderId";
              super.scanResultColor = Colors.blue;
             });
            setProcessed(operation,orderId);
          } else{
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




  
Future<bool> isProcessed(String operation, int orderId) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operation, orderId);
    int? lastTimestamp = prefs.getInt(key);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    if (lastTimestamp == null || (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
      return false;
    }
    return true;
}

void setProcessed(String operation, int orderId) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operation, orderId);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(key, currentTimeMillis);
}


 String _makeScanKey(String operation, int orderId) {
    String key = '$operation$orderId';
    return base64.encode(utf8.encode(key));
  }
}
