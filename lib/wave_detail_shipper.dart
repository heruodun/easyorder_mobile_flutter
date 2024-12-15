import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/wave_detail.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'constants.dart';

class WaveDetailsShipperScreen extends WaveDetailsScreen {
  // 构造函数：接收一个 Wave 对象并将其传递给父类构造函数
  const WaveDetailsShipperScreen({super.key, required super.wave});

  // 实现 createState() 返回 _WaveDetailsPickerScreenState 实例
  @override
  WaveDetailsScreenState createState() => _WaveDetailsShipperScreenState();
}

class _WaveDetailsShipperScreenState extends WaveDetailsScreenState {
  bool _isRequestInProgress = false; // 用于跟踪HTTP请求的状态

  void _initiateHttpRequest() async {
    // 在发送HTTP请求前更新状态
    setState(() {
      _isRequestInProgress = true;
    });

    try {
      await _makeHttpRequest(context, widget.wave.waveId);
      // 请求完成后更新状态
      setState(() {
        _isRequestInProgress = false;
      });
    } catch (e) {
      // 如果HTTP请求失败，处理错误
      setState(() {
        _isRequestInProgress = false;
        // 更新错误信息
        super.errorMessage = e.toString();
      });
    }
  }

  Future<void> _makeHttpRequest(BuildContext context, int waveId) async {
    // 将Wave对象序列化为JSON
    try {
      // 发送HTTP POST请求，将Wave保存到服务器上
      final response = await httpClient(
        uri: Uri.parse('$httpHost/app/order/wave/ship'),
        body: {'waveId': waveId},
        method: "POST",
      );

      // 检查服务器响应是否成功
      if (response.isSuccess) {
        // 如果请求成功，显示成功提示
        Vibration.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('开始送货了!'),
          ),
        );
        // 然后关闭当前屏幕
        Navigator.pop(context);
      } else {
        // 如果请求失败，显示失败提示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('提交失败，请重试!')),
        );
      }
    } catch (e) {
      // 遇到异常，显示错误信息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (super.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('加载波次详情...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (super.errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('加载错误')),
        body: Center(child: Text(super.errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('波次详情'),
      ),
      body: buildWaveDetailsScreen(context), // 假设这是已定义的方法
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _isRequestInProgress ? null : _initiateHttpRequest,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50), // 宽度与屏幕一样宽，高度适宜
          ),
          child: _isRequestInProgress
              ? const SizedBox(
                  width: double.infinity,
                  height: 16.0,
                  child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2.0)),
                )
              : const Text('开始送货'),
        ),
      ),
    );
  }
}
