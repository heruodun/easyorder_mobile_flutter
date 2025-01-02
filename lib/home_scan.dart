import 'dart:async';

import 'package:easyorder_mobile/constants.dart';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/my.dart';
import 'package:easyorder_mobile/user_data.dart';
import 'package:easyorder_mobile/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

const boxSize = 400.0;

class HomePage extends StatefulWidget {
  User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  ScanResult? _barcode; // 当前扫描的条码
  late ScanKitController _controller;
  StreamSubscription<Object?>? _subscription;
  bool _isProcessing = false;
  bool _isResultDisplayed = false;
  String scanResultText = "扫码中...";
  String scanInfoText = "请扫码！";
  Color scanResultColor = Colors.grey;

  late List<Role> roles;
  late List<Role> itemRoles = [];

  @override
  void initState() {
    super.initState();
    _controller = ScanKitController();
    roles = widget.user.roleInfoList!.cast<Role>();

    for (Role role in roles) {
      if (role.roleCode == jianhuoRoleCode) {
        itemRoles.add(role);
      }
      if (role.roleCode == songhuoRoleCode) {
        itemRoles.add(role);
      }
      //扫码角色
      if (role.roleType == 1) {
        itemRoles.add(role);
      }
    }

    _subscription = _controller.onResult.listen(_handleBarcode);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(ScanResult barcode) {
    debugPrint("Scanning result: ${barcode.originalValue}");
    if (!_isProcessing) {
      setState(() {
        _isProcessing = true;
        _barcode = barcode;
        _processScanResult(_barcode!.originalValue);
      });
    }
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
      // 根据当前角色执行不同的处理逻辑
      doProcess(result!, itemRoles[_currentIndex]);
    } else {
      scanResultText = "非有效单号";
      scanResultColor = Colors.red;
    }

    setState(() {
      _isResultDisplayed = true;
      scanInfoText = "扫码完成";
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isResultDisplayed = false;
      scanResultText = "扫码中...";
      scanInfoText = "请扫码！";
      _isProcessing = false;
    });
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
          _buildResultLayer(),
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
                  Expanded(child: Center(child: _buildBarcodeText())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultLayer() {
    if (!_isResultDisplayed) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.black.withOpacity(0.5),
      alignment: Alignment.center,
      child: Text(
        scanResultText,
        style: TextStyle(
            color: scanResultColor, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBarcodeText() {
    return Text(
      scanInfoText,
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white, fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _currentIndex < itemRoles.length
              ? Text(itemRoles[_currentIndex].roleName)
              : const Text("我的")),
      body: _currentIndex < itemRoles.length
          ? buildScanScreen(context)
          : MyScreen(
              user: widget.user,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index < itemRoles.length) {
            // 切换到角色页面时重置扫码信息
            setState(() {
              _currentIndex = index;
              scanResultText = "扫码中...";
              scanInfoText = "请扫码！";
              _isResultDisplayed = false;
              _isProcessing = false;
            });
          } else {
            // 点击"我的"时，不重置扫码信息
            // 只需更改当前索引
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: List.generate(itemRoles.length + 1, (index) {
          if (index < itemRoles.length) {
            return BottomNavigationBarItem(
              icon: const Icon(Icons.camera),
              label: itemRoles[index].roleName,
            );
          } else {
            return const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "我的",
            );
          }
        }),
      ),
    );
  }

  void doProcess(String result, Role role) async {
    String operation = role.roleName;
    String operationCode = role.roleCode;

    RegExp pattern = RegExp(r'\d+');
    RegExpMatch? match = pattern.firstMatch(result);

    String? orderIdStr = match?.group(0);
    if (orderIdStr == null) {
      //异常了
      return;
    }

    int orderId = int.parse(orderIdStr);

    bool hasProcessed = await isProcessed(operationCode, orderId);

    if (hasProcessed) {
      scanResultText = "已$operation扫码\n$orderId";
      scanResultColor = Colors.yellow;
    } else {
      try {
        var response = await httpClient(
          uri: Uri.parse('$httpHost/app/order/scan'),
          body: {
            'orderIdQr': result,
            'operation': operationCode,
          },
          method: 'POST',
        );
        if (response.isSuccess) {
          Vibration.vibrate();
          setState(() {
            scanResultText = "$operation扫码成功\n$orderId";
            scanResultColor = Colors.green;
          });
          setProcessed(operationCode, orderId);
        } else {
          String msg = response.message;
          setState(() {
            scanResultText = "$msg\n$orderId";
            scanResultColor = Colors.red;
          });
        }
      } catch (e) {
        setState(() {
          scanResultText = "扫码异常\n$orderId";
          scanResultColor = Colors.red;
        });
      }
    }
  }

  Future<bool> isProcessed(String operationCode, int orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operationCode, orderId);
    int? lastTimestamp = prefs.getInt(key);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    if (lastTimestamp == null ||
        (currentTimeMillis - lastTimestamp) >= 5 * 60 * 1000) {
      return false;
    }
    return true;
  }

  void setProcessed(String operationCode, int orderId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = _makeScanKey(operationCode, orderId);
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    prefs.setInt(key, currentTimeMillis);
  }

  String _makeScanKey(String operationCode, int orderId) {
    String key = 'prefix$operationCode$orderId';
    return key;
  }
}
