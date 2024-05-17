import 'dart:async';
import 'dart:convert';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/wave_detail_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'login.dart';
import 'user_data.dart';
import 'wave_data.dart';
import 'package:vibration/vibration.dart';



// 拣货用的
class ScanPickerScreen extends ScanScreenStateful {
  final Wave? wave; // 接收从上一个界面传递过来的Wave对象
  final int type;

  const ScanPickerScreen({super.key, this.wave, required this.type}) : super();
  
  @override
  _ScanPickerState createState() => _ScanPickerState();
}

class _ScanPickerState extends ScanScreenState<ScanPickerScreen> {
  
  late Wave _wave;

   // 从服务器获取波次数据的函数
Future<Wave> fetchWavesById(int waveId) async {
  final response = await http.get(
    Uri.parse('$httpHost/mobile/waveInfo?waveId=$waveId'),
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

 void fetchData() {
    // 服务器返回的JSON响应会被转换成一个包含Wave对象的列表

    fetchWavesById(widget.wave!.waveId).then((data) {
      setState(() {
        _wave = data;
        print('fetchWavesById $data');
      });
    });
  }





  @override
  void initState() {
    super.initState();
    _wave = widget.wave!;
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


  @override
  Widget build(BuildContext context) {

    String appBarStr;
    if(widget.type == 1){
      appBarStr = "加入波次";
    }
    else{
      appBarStr = "撤出波次";
    }

    return Scaffold(
      appBar: AppBar(
        title:  Text(appBarStr),
      
      ),

     
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text('波次编号: ${_wave.waveId}'),
            subtitle: Text('共计${_wave.waveDetail!.addressCount}个地址, ${_wave.waveDetail?.totalCount}个订单\n创建时间: ${_wave.createTime}'),
            onTap: () {
              // 点击时导航到波次详情页面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaveDetailsPickerScreen(wave: _wave),
                  ),
            );
            },
          ),
          super.buildScanScreen(context),
        ],
      ),
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
      int waveId = widget.wave!.waveId;
      int type = widget.type;

      if(type != 1){
        type = -1;
      }
      

    bool hasProcessed =  await isProcessed(orderId, waveId, type);

    if(hasProcessed){
      if(type == 1){
      super.scanResultText = "已加入波次\n$orderId";

      }else{
      super.scanResultText = "已撤出波次\n$orderId";

      }
      super.scanResultColor = Colors.yellow;
    }
    else{

      User? user = await User.getCurrentUser(); 

      try {

        var response = await http.post(
        Uri.parse('$httpHost2/wave/operation'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
        'wave_id': waveId,
        'wave_alias': widget.wave!.waveAlias,
          'order_id': orderId,
          'operator': user!.actualName,
          'operation': type,
          'wave_create_time': widget.wave!.createTime
        }),
      );

        print(response.statusCode);

       
        if (response.statusCode == 200) {

          Vibration.vibrate();

          setState(() {

          if(type == 1){
            super.scanResultText = "加入波次成功\n$orderId";
            fetchData();
          }
          else{
            super.scanResultText = "撤出波次成功\n$orderId";
            fetchData();
          }
          super.scanResultColor = Colors.blue;
          });

         
          

          setProcessed(orderId, waveId, type);
        } else{

          String body = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> data = jsonDecode(body);

          String msg = data['msg'];


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




  
Future<bool> isProcessed(int orderId, int waveId, int type) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(orderId, waveId, type);
    int? lastTimestamp = prefs.getInt(key);
    print('lastTimestamp $lastTimestamp');
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
     print('currentTimeMillis $currentTimeMillis');

    if (lastTimestamp == null || (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
      return false;
    }
    return true;
}

void setProcessed(int orderId, int waveId, int type) async {
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(orderId, waveId, type);
    String revertKey = _makeScanKey(orderId, waveId, -type);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(key, currentTimeMillis);
    prefs.remove(revertKey);
}


 String _makeScanKey(int orderId, int waveId, int type) {
    return '${orderId}_${waveId}_$type';
  }
}

