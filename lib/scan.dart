import 'dart:async';
import 'dart:convert';
import 'package:easyorder_mobile/wave_list.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'login.dart';
import 'scanner_button_widgets.dart';
import 'scanner_error_widget.dart';
import 'wave_data.dart';
import 'package:vibration/vibration.dart';
import 'package:beep_player/beep_player.dart';

import 'wave_detail.dart';




class ScanScreen extends StatefulWidget {
  final Wave? wave; // 接收从上一个界面传递过来的Wave对象
  final int type;

  const ScanScreen({super.key, this.wave, required this.type});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver{
  MobileScannerController controller = MobileScannerController(
  torchEnabled: false, useNewCameraSelector: true,
  // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    returnImage: true,
  );
  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;
  bool isProcessing = false;
  bool _isResultDisplayed = false; // 控制处理结果的显示与隐藏
   late String _scanResultText = "扫码中...";
   late Color _scanResultColor = Colors.grey;

  late Wave _wave;

   static const BeepFile _beepFile = BeepFile('assets/audio/beep.ogg');


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



  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        '请扫码!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? '无扫码结果',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());

    BeepPlayer.load(_beepFile);

    _wave = widget.wave!;
  }

 @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
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
                    builder: (context) => WaveDetailsScreen(wave: _wave),
                  ),
            );
            },
          ),
          
          Expanded(
           child:  Stack(
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            // fit: BoxFit.contain,
          ),

           _buildResultLayer(), // 处理结果

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  // StartStopMobileScannerButton(controller: controller),
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                  SwitchCameraButton(controller: controller),
                  AnalyzeImageFromGalleryButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultLayer() {
    if (!_isResultDisplayed) {
      return const SizedBox.shrink(); // 如果不需要显示结果，返回一个空的小部件
    }

    return Container(
      color: Colors.black.withOpacity(0.5), // 半透明背景
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _scanResultText,
            style: TextStyle(color: _scanResultColor, fontSize: 24),
          ),
        ],
      ),
    );
  }

   void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {

       if (!isProcessing) {

          setState(() {
            isProcessing = true;
            _barcode = barcodes.barcodes.firstOrNull;
            if (_barcode != null) {
              _processScanResult(_barcode!.displayValue); // 处理扫描结果
            }
            else{
              print("null");
            }
            
          });
    }
    }
  }


  Future<void> _processScanResult(String? result) async {
      // 检查扫描结果的格式
    if(result != null && RegExp(r'^\d+\$xiaowangniujin$').hasMatch(result)){
        _sendHttpCall(result);
    }
    else{
       _scanResultText = "非有效订单号";
      _scanResultColor = Colors.red;
    }

     // 显示结果，1秒后隐藏结果层并重置状态
    setState(() {
        _isResultDisplayed = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
        _isResultDisplayed = false;
        isProcessing = false;
    });

  }

  void _sendHttpCall(String result) async {
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
      _scanResultText = "已加入波次\n$orderId";

      }else{
      _scanResultText = "已撤出波次\n$orderId";

      }
      _scanResultColor = Colors.yellow;
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
          'operator': user.actualName,
          'operation': type,
          'wave_create_time': widget.wave!.createTime
        }),
      );

        print(response.statusCode);

       
        if (response.statusCode == 200) {

          Vibration.vibrate();

          BeepPlayer.play(_beepFile);


          setState(() {

          if(type == 1){
            _scanResultText = "加入波次成功\n$orderId";
            fetchData();
          }
          else{
            _scanResultText = "撤出波次成功\n$orderId";
            fetchData();
          }
          _scanResultColor = Colors.blue;
          });

         
          

          setProcessed(orderId, waveId, type);
        } else{

          String body = utf8.decode(response.bodyBytes);
          final Map<String, dynamic> data = jsonDecode(body);

          String msg = data['msg'];


           setState(() {
          _scanResultText = "$msg\n$orderId";
          _scanResultColor = Colors.red;
           });


          
        }
      } catch (e) {
         setState(() {
          
          _scanResultText = "扫码异常\n$orderId";
          _scanResultColor = Colors.red;

        });



      }

    }
   
  }



  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
    BeepPlayer.unload(_beepFile);
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

