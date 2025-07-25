import 'dart:async';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar.dart';
import 'main.dart';
import 'scanner_button_widgets.dart';
import 'scanner_error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

abstract class ScanScreenState<T extends ScanScreenStateful> extends State<T>
    with RouteAware, WidgetsBindingObserver {
  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;
  bool _isProcessing = false;
  bool _isResultDisplayed = false; // 控制处理结果的显示与隐藏
  late String scanResultText = "扫码中...";
  late Color scanResultColor = Colors.grey;
  String scanInfoText = "请扫码！";

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);

    controller.start();
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

  double _zoomFactor = 0.0;

  Widget _buildZoomScaleSlider() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final TextStyle labelStyle = Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                '0%',
                overflow: TextOverflow.fade,
                style: labelStyle,
              ),
              Expanded(
                child: Slider(
                  value: _zoomFactor,
                  onChanged: (value) {
                    setState(() {
                      _zoomFactor = value;
                      controller.setZoomScale(value);
                    });
                  },
                ),
              ),
              Text(
                '100%',
                overflow: TextOverflow.fade,
                style: labelStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildScanScreen(BuildContext context) {
    return Stack(
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
            child: Column(
              children: [
                if (!kIsWeb) _buildZoomScaleSlider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleFlashlightButton(controller: controller),
                    // StartStopMobileScannerButton(controller: controller),
                    Expanded(child: Center(child: _buildBarcode(_barcode))),
                    // SwitchCameraButton(controller: controller),
                    AnalyzeImageFromGalleryButton(
                      controller: controller,
                      onBarcodeDetected: (code) async {
                        if (code != null) {
                          await _processScanResult(code); // 间接调用自身的处理函数
                        } else {
                          setState(() {
                            scanResultText = "没有识别到条码";
                            scanResultColor = Colors.red;
                            _isResultDisplayed = true;
                          });
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            _isResultDisplayed = false;
                            scanResultText = "扫码中...";
                            scanResultColor = Colors.grey;
                          });
                        }
                      },
                    ),
                  ],
                ),
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
            style: TextStyle(
                color: scanResultColor,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    final provider =
        Provider.of<BottomNavigationBarProvider>(context, listen: false);
    if (mounted && canProcess(provider.currentLabel)) {
      debugPrint(
          "cur run wiget ${widget.runtimeType.toString()}  ${provider.currentLabel}");

      if (!_isProcessing) {
        setState(() {
          _isProcessing = true;
          _barcode = barcodes.barcodes.firstOrNull;
          if (_barcode != null) {
            _processScanResult(_barcode!.displayValue); // 处理扫描结果
          } else {
            print("null");
          }
        });
      }
    }
  }

  Widget _buildBarcode(Barcode? value) {
    if (!_isResultDisplayed) {
      scanInfoText = "请扫码！";
    } else {
      if (value != null) {
        scanInfoText = value.rawValue!;
      }
    }

    return Text(
      scanInfoText,
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  Future<bool> isMatch(result) async {
    User? user = await User.getCurrentUser();
    List<String?>? scanRuleList = user?.scanRuleList;
    String tag = user!.tenant!.tag;
    if (result != null && (result.endsWith(tag))) {
      return true;
    }
    for (String? rule in scanRuleList ?? []) {
      if (rule != null && result != null && result.endsWith(rule)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _processScanResult(String? result) async {
    // 检查扫描结果的格式
    if (await isMatch(result)) {
      doProcess(result!);
    } else {
      scanResultText = "非有效单号";
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
      scanResultText = "扫码中...";
      scanResultColor = Colors.grey;
      scanInfoText = "请扫码！";
    });
  }

  void doProcess(String result);

  bool canProcess(String currentLabel);

  Future<bool> isProcessed(String operationCode, String processTag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operationCode, processTag);
    int? lastTimestamp = prefs.getInt(key);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    if (lastTimestamp == null ||
        (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
      return false;
    }
    return true;
  }

  void setProcessed(String operationCode, String processTag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operationCode, processTag);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(key, currentTimeMillis);
  }

  String _makeScanKey(String operationCode, String processTag) {
    String key = 'prefix$operationCode$processTag';
    return key;
  }

  @override
  Future<void> dispose() async {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    // await controller.dispose();
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
