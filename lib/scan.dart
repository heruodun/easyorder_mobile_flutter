import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'login.dart';
import 'scanner_button_widgets.dart';
import 'scanner_error_widget.dart';
import 'wave_data.dart';



class ScanScreen extends StatefulWidget {
  final Wave? wave; // 接收从上一个界面传递过来的Wave对象
  final int type;

  const ScanScreen({super.key, this.wave, required this.type});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver{
  MobileScannerController controller = MobileScannerController(
  torchEnabled: true, useNewCameraSelector: true,
  // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    returnImage: true,
  );
  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;
  bool _isReadyToScan = true;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        '请扫码!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('扫码界面'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text('波次编号: ${widget.wave!.waveId}'),
            subtitle: Text('共计${widget.wave!.waveDetail!.addressCount}个地址, ${widget.wave!.waveDetail!.totalCount}个订单\n创建时间: ${widget.wave!.createTime}'),
            onTap: () {
              // 执行点击操作逻辑，如果需要的话
            },
          ),
          Expanded(
              child: StreamBuilder<BarcodeCapture>(
                stream: controller.barcodes,
                builder: (context, snapshot) {
                  final barcode = snapshot.data;

                  if (barcode == null) {
                    return const Center(
                      child: Text(
                        'Your scanned barcode will appear here!',
                      ),
                    );
                  }

                  final barcodeImage = barcode.image;

                  if (barcodeImage == null) {
                    return const Center(
                      child: Text('No image for this barcode.'),
                    );
                  }

                  return Image.memory(
                    barcodeImage,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text('Could not decode image bytes. $error'),
                      );
                    },
                    frameBuilder: (
                      BuildContext context,
                      Widget child,
                      int? frame,
                      bool? wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded == true || frame != null) {
                        return Transform.rotate(
                          angle: 90 * pi / 180,
                          child: child,
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),

          Expanded(
           child:  Stack(
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.contain,
          ),
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
                  StartStopMobileScannerButton(controller: controller),
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

   void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _isReadyToScan = false;
        _barcode = barcodes.barcodes.firstOrNull;
         if (_barcode != null) {
          print('show code${_barcode!.displayValue}'); // 显示扫描到的二维码内容
          _processScanResult(_barcode!.displayValue); // 处理扫描结果
        }
        else{
          print("null");
        }
        
      });
    }
  }


  void _processScanResult(String? result) {
    if(result != null){
      // 检查扫描结果的格式
      if (RegExp(r'^\d+\$xiaowangniujin$').hasMatch(result)) {
        _sendHttpCall(result);
      } else {
        _showDialog('非有效订单号');
      }
    }
    else{
      _showDialog('非有效订单号');
    }
  }

  void _sendHttpCall(String result) async {

      RegExp pattern = RegExp(r'\d+');
      RegExpMatch? match = pattern.firstMatch(result);
      

    if(widget.type == 1){
      //添加
    }
    else {
      //删除
      widget.type == 0;
    }

    User? user = await User.getCurrentUser(); 

    try {

      var response = await http.post(
      Uri.parse('$httpHost2/wave/operation'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
       'wave_id': widget.wave!.waveId,
       'wave_alias': widget.wave!.waveAlias,
        'order_id': match!.group(0),
        'operator': user.actualName,
        'operation': widget.type,
      }),
    );

      

       print('${widget.wave!.waveId}');


      print(response.statusCode);
      if (response.statusCode == 200) {
        if(widget.type == 1){
          _showDialog('添加成功');
        }
        else{
          _showDialog('删除成功');
        }
      } else {
        _showDialog('失败了，请重试');
      }
    } catch (e) {
      _showDialog('失败了，请重试~');
    }
  }

void _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // 这会阻止用户通过点击遮罩层外部来关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('扫码结果'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // 自动关闭对话框
      }
      _isReadyToScan = true; // 重新开启扫描
    });
}



  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}

