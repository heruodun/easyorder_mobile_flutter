import 'package:easyorder_mobile/wave_detail.dart';
import 'package:flutter/material.dart';

class WaveDetailsPickerScreen extends WaveDetailsScreen {
  // 构造函数：接收一个 Wave 对象并将其传递给父类构造函数
  const WaveDetailsPickerScreen({super.key, required super.wave});

  // 实现 createState() 返回 _WaveDetailsPickerScreenState 实例
  @override
  WaveDetailsScreenState createState() => _WaveDetailsPickerScreenState();
}

class _WaveDetailsPickerScreenState extends WaveDetailsScreenState {
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
        body: buildWaveDetailsScreen(context));
  }
}
