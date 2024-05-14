import 'dart:async';
import 'dart:convert';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/wave_detail_shipper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'wave_data.dart';


// 送货
class ScanShipperScreen extends ScanScreenStateful {

  const ScanShipperScreen({super.key}) : super();
  
  @override
  _ScanShipperState createState() => _ScanShipperState();
}

class _ScanShipperState extends ScanScreenState<ScanShipperScreen> {

  


  @override
  Widget build(BuildContext context) {

    String appBarStr = "送货扫码";
    

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
      RegExp pattern = RegExp(r'\d+');
      RegExpMatch? match = pattern.firstMatch(result);

      String? orderIdStr = match?.group(0);
      if(orderIdStr == null){
        //异常了
        return;
      }

      int orderId = int.parse(orderIdStr);

      
    try{
         final response = await http.get(
          Uri.parse('$httpHost/mobile/waveInfoFromOrderId?orderId=$orderId'),);

        if (response.statusCode == 200) {
          // Decode the JSON response.body into a Dart object.
          String body = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> data = jsonDecode(body);
          print('fetch by id : $data');
          if (data['code'] == 0) {
            Wave wave = Wave.fromJson(data['data']);
               setProcessed(orderId);
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WaveDetailsShipperScreen(wave: wave),
              ),
            );

            super.controller.stop();
          
          } else {
            String body = utf8.decode(response.bodyBytes);
            final Map<String, dynamic> data = jsonDecode(body);

            String msg = data['msg'];

            setState(() {
            super.scanResultText = "$msg\n$orderId";
            super.scanResultColor = Colors.red;
            });

          }
        }
        } catch (e) {
          print(e);
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
    if (lastTimestamp == null || (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
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

   // 从服务器获取波次数据的函数
Future<Wave> fetchWavesByOrderId(int orderId) async {
  final response = await http.get(
    Uri.parse('$httpHost/mobile/waveInfoFromOrderId?waveId=$orderId'),
  );

  if (response.statusCode == 200) {
    // Decode the JSON response.body into a Dart object.
    String body = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> data = jsonDecode(body);
    print('fetch by id : $data');
    if (data['code'] == 0) {
      return Wave.fromJson(data['data']);

    } else {
      throw Exception('Invalid response code: ${data['code']}');
    }
  } else {
    throw Exception('Failed to load waves: ${response.statusCode}');
  }
}




