import 'dart:async';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:provider/provider.dart';
import 'bottom_nav_bar.dart';
import 'main.dart';
import 'package:beep_player/beep_player.dart';

const boxSize = 400.0;

abstract class ScanScreenStateful extends StatefulWidget {
  const ScanScreenStateful({super.key});

  @override
  ScanScreenState createState();
}

abstract class ScanScreenState<T extends ScanScreenStateful> extends State<T>
    with RouteAware, WidgetsBindingObserver {
  ScanResult? _barcode;
  final ScanKitController _controller = ScanKitController();

  StreamSubscription<Object?>? _subscription;
  bool _isProcessing = false;
  bool _isResultDisplayed = false; // 控制处理结果的显示与隐藏
  String scanResultText = "扫码中...";
  String scanInfoText = "请扫码！";
  Color scanResultColor = Colors.grey;

  static const BeepFile _beepFile = BeepFile('assets/audios/beep.ogg');

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    _subscription = _controller.onResult.listen(_handleBarcode);

    BeepPlayer.load(_beepFile);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = _controller.onResult.listen(_handleBarcode);

        break;
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
    }
  }

  Widget buildScanScreen(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var left = screenWidth - boxSize;
    var top = screenHeight - boxSize;
    var rect = Rect.fromLTWH(left, top, boxSize, boxSize);
    final ScanKitWidget scanKitWidget = ScanKitWidget(
        controller: _controller, continuouslyScan: true, boundingBox: rect);

    return SafeArea(
        child: Stack(
      children: [
        scanKitWidget,
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    _controller.switchLight();
                  },
                  icon: const Icon(
                    Icons.flash_on_rounded,
                    color: Colors.white,
                    size: 28,
                  )),
              IconButton(
                  onPressed: () {
                    _controller.pickPhoto();
                  },
                  icon: const Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 28,
                  ))
            ],
          ),
        ),

        _buildResultLayer(), // 处理结果

        Align(
          alignment: Alignment.center,
          child: Container(
            width: boxSize,
            height: boxSize,
            decoration: const BoxDecoration(
              border: Border(
                  left: BorderSide(color: Colors.blue, width: 1),
                  right: BorderSide(color: Colors.blue, width: 1),
                  top: BorderSide(color: Colors.blue, width: 1),
                  bottom: BorderSide(color: Colors.blue, width: 1)),
            ),
          ),
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
                Expanded(child: Center(child: _buildBarcode(_barcode))),
              ],
            ),
          ),
        ),
      ],
    ));
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

  void _handleBarcode(ScanResult barcode) {
    debugPrint(
        "scanning result:value=${barcode.originalValue} scanType=${barcode.scanType}");
    final provider =
        Provider.of<BottomNavigationBarProvider>(context, listen: false);
    if (mounted && canProcess(provider.currentLabel)) {
      debugPrint(
          "cur run wiget ${widget.runtimeType.toString()}  ${provider.currentLabel}");

      if (!_isProcessing) {
        setState(() {
          _isProcessing = true;
          _barcode = barcode;
          if (_barcode != null) {
            _processScanResult(_barcode!.originalValue); // 处理扫描结果
          } else {
            debugPrint("_barcode is null");
          }
        });
      }
    }
  }

  Widget _buildBarcode(ScanResult? value) {
    if (!_isResultDisplayed) {
      scanInfoText = "请扫码！";
    } else {
      if (value != null) {
        scanInfoText = value.originalValue;
      }
    }

    return Text(
      scanInfoText,
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white, fontSize: 13),
    );
  }

  Future<bool> isMatch(result) async {
    User? user = await User.getCurrentUser();
    List<String?>? scanRuleList = user?.scanRuleList;
    if (result != null && (RegExp(r'^\d+\$xiaowangniujin$').hasMatch(result))) {
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

  @override
  Future<void> dispose() async {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    _controller.dispose();
    super.dispose();
    BeepPlayer.unload(_beepFile);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }
}
