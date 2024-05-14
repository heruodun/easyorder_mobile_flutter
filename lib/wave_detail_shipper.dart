import 'package:easyorder_mobile/wave_detail.dart';
import 'package:flutter/material.dart';



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
      // TODO: 发送你的HTTP请求
      // await yourHttpService.sendRequest();

      // 假设这是一个异步操作，使用await等待操作完成
      await Future.delayed(Duration(seconds: 2)); // 模拟网络请求延迟

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
          child: _isRequestInProgress
              ? const SizedBox(
                  width: double.infinity,
                  height: 16.0,
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                )
              : const Text('发起请求'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50), // 宽度与屏幕一样宽，高度适宜
          ),
        ),
      ),
    );
  }
}