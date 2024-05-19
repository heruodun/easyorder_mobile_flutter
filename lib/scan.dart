import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar.dart';
import 'main.dart';
import 'scanner_button_widgets.dart';
import 'scanner_error_widget.dart';
import 'package:beep_player/beep_player.dart';


 MobileScannerController controller = MobileScannerController(
  torchEnabled: false, useNewCameraSelector: true,
  // formats: [BarcodeFormat.qrCode]
    // facing: CameraFacing.front,
    // detectionSpeed: DetectionSpeed.normal
    // detectionTimeoutMs: 1000,
    returnImage: true,
  );

abstract class ScanScreenStateful extends StatefulWidget {
  const ScanScreenStateful({super.key});

  @override
  ScanScreenState createState();
}

abstract class ScanScreenState<T extends ScanScreenStateful> extends State<T> with RouteAware, WidgetsBindingObserver{
 
  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;
  bool _isProcessing = false;
  bool _isResultDisplayed = false; // 控制处理结果的显示与隐藏
  late String scanResultText = "扫码中...";
  late Color scanResultColor = Colors.grey;

  static const BeepFile _beepFile = BeepFile('assets/audios/beep.ogg');

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);

    controller.start();
    
    BeepPlayer.load(_beepFile);
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
        // unawaited(controller.stop());
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  Widget buildScanScreen(BuildContext context) {
     return 
        
           Stack(
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
      );
      

  }


  @override
  Widget build(BuildContext context) {

    return buildScanScreen(context);
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
            scanResultText,
            style: TextStyle(color: scanResultColor, fontSize: 24),
          ),
        ],
      ),
    );
  }

   void _handleBarcode(BarcodeCapture barcodes) {
     final provider = Provider.of<BottomNavigationBarProvider>(context, listen: false);
    if (mounted) {
      if(widget.runtimeType.toString() == "ScanCheckerScreen" && provider.currentLabel != "配货"){
        return;
      }

      if(widget.runtimeType.toString() == "ScanMakerScreen" && provider.currentLabel != "对接"){
        return;
      }

      if(widget.runtimeType.toString() == "ScanPickerScreen" && provider.currentLabel != "拣货"){
        return;
      }

      if(widget.runtimeType.toString() == "ScanShipperScreen" && provider.currentLabel != "送货"){
        return;
      }

      print("cur run wiget ${widget.runtimeType.toString()}  ${provider.currentLabel}");


       if (!_isProcessing) {

          setState(() {
            _isProcessing = true;
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

  Future<void> _processScanResult(String? result) async {
      // 检查扫描结果的格式
    if(result != null && RegExp(r'^\d+\$xiaowangniujin$').hasMatch(result)){
        doProcess(result);
    }
    else{
       scanResultText = "非有效订单号";
      scanResultColor = Colors.red;
    }
     // 显示结果，1秒后隐藏结果层并重置状态
    setState(() {
        _isResultDisplayed = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
        _isResultDisplayed = false;
        _isProcessing = false;
    });

  }
  void doProcess(String result);



  @override
  Future<void> dispose() async {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    // await controller.dispose();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    BeepPlayer.unload(_beepFile);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

   @override
  void didPush() {
    // 当前页面推入时
    controller.start();
    
  }

  @override
  void didPopNext() {
    // 当从其他页面返回到当前页面时
       controller.start();
  }

  @override
  void didPop() {
    // 当前页面被弹出时
      controller.stop();
  }

  @override
  void didPushNext() {
    // 当前页面推入其他页面时
      controller.stop();
  }

}

