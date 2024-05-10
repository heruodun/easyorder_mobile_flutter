import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'wave_data.dart';




List<TimeLine> parseTimeLine(String data) {
  List<String> lines = data.split("\n\n");
  List<TimeLine> timelines = []; // 初始化一个用于存储TimeLine对象的list

  // 循环处理每一段数据
  for (var line in lines) {
    List<String> parts = line.split('，');
    if (parts.length >= 2) { // 确保有足够的数据进行解析
      try {
        String person = parts[0].split('：')[1];
        String time = parts[1].split('：')[1]; // 假设时间戳为整数
        int type = getTypeFromDescription(line); // 获取类型

        timelines.add(TimeLine(
          type: type,
          person: person,
          time: time,
        ));
      } catch (e) {
        // 可以在这里处理错误，例如解析错误
      }
    }
  }


   print('timelines ${timelines}'); 

  return timelines;
}

// 一个辅助函数，用于根据行描述返回时间线对象的类型
int getTypeFromDescription(String description) {
  if (description.contains('打单')) {
    return 1;
  } else if (description.contains('配货')) {
    return 2;
  } else if (description.contains('对接')) {
    return 3;
  } else if (description.contains('对接收货')) {
    return 4;
  } else if (description.contains('拣货')) {
    return 4;
  } else if (description.contains('送货')) {
    return 5;
  }
  return 0; // 使用0作为未知类型的默认值
}

// 使用前面给出的formatTimestamp函数
String formatTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(date);
}







class WaveDetailsScreen extends StatefulWidget {
  final Wave wave;

  const WaveDetailsScreen({super.key, required this.wave});

  @override
  _WaveDetailsScreenState createState() => _WaveDetailsScreenState();
}

class _WaveDetailsScreenState extends State<WaveDetailsScreen> {
  late Wave _wave;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWaveDetails();
  }

  void _fetchWaveDetails() {
    try {

        setState(() {
          _wave = widget.wave;
          _isLoading = false;
        });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load wave details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loading Wave Details...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text(_errorMessage)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('波次详情'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 放置在SingleChildScrollView外面的Padding
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '波次编号: ${_wave.waveId}，共计: ${_wave.waveDetail!.addressCount}个地址\n时间：${_wave.createTime}',
            ),
          ),
          // SingleChildScrollView 包含剩余的可滚动内容
          Expanded(
            child: SingleChildScrollView(
              child: 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ..._wave.waveDetail!.addresses.map(
                    (addressSummary) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: ExpansionTile(
                          title: Text('${addressSummary.address} (共计${addressSummary.orders.length}个订单)'),
                          children: addressSummary.orders.asMap().entries.map((entry) {

                            int idx = entry.key;
                            var orderDetail = entry.value;
                            Color? bgColor = idx % 2 == 0 ? Colors.grey[200] : Colors.white; // 偶数索引使用浅灰色, 奇数索引使用白色

                            String printTimeStr = formatTimestamp(orderDetail.printTime);

                            return Container(
                                    color: bgColor,
                             child: ListTile(
                              title: Text(orderDetail.orderId.toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('地址: ${orderDetail.address}'),
                                  Text('订单状态: ${orderDetail.curStatus}'),
                                  Text('处理时间: ${orderDetail.curTime}'),
                                  Text('打单时间: $printTimeStr'),
                                  Text('货物详情: ${orderDetail.content}'),
                                  const Text('订单轨迹:'),
                                  
                                  TimelineWidget(timelines: parseTimeLine(orderDetail.orderTrace),),
                                  
                                ],
                              ),
                              isThreeLine: true,
                            )
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class TimelineWidget extends StatelessWidget {
  final List<TimeLine> timelines;

  const TimelineWidget({super.key, required this.timelines});

  // 提供一个方法，用于将TimeLine对象的类型映射到具体的图标和描述
  Map<String, dynamic> _mapEvent(TimeLine timeline) {
    IconData icon;
    String label;
    switch (timeline.type) {
      case 1: // 打单
        icon = Icons.print;
        label = '打单';
        break;
      case 2: // 配货
        icon = Icons.assignment;
        label = '配货';
        break;
      case 3: // 对接
        icon = Icons.anchor;
        label = '对接';
        break;
      case 4: // 拣货
        icon = Icons.receipt;
        label = '拣货';
        break;
      case 5: // 送货
        icon = Icons.local_shipping;
        label = '送货';
        break;
      default:
        icon = Icons.help_outline;
        label = '未知';
    }
    return {'icon': icon, 'label': label, 'time': timeline.time, 'person': timeline.person};
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> eventWidgets = timelines.map((TimeLine timeline) {
      var mappedEvent = _mapEvent(timeline);
      // 根据时间和参与者是否存在来决定是否展示该行
      if (mappedEvent['time']?.isNotEmpty == true && mappedEvent['person']?.isNotEmpty == true) {
        return Row(
          children: [
            Icon(mappedEvent['icon'] as IconData, size: 16),
            const SizedBox(width: 8),
            Text('${mappedEvent['label']} ${mappedEvent['person']} ${mappedEvent['time']}'),
          ],
        );
      }
      return SizedBox.shrink(); // 如果时间或参与者为空，则返回一个空的SizedBox
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: eventWidgets,
    );
  }
}

class TimeLine {
  int type;
  String person;
  String time;

  TimeLine({required this.type, required this.person, required this.time});
}
