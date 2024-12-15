import 'package:easyorder_mobile/constants.dart';
import 'package:flutter/material.dart';
import 'wave_data.dart';

List<TimeLine> parseTimeLine(String data) {
  List<String> lines = data.split("\n\n");
  List<TimeLine> timelines = []; // 初始化一个用于存储TimeLine对象的list

  // 循环处理每一段数据
  for (var line in lines) {
    List<String> parts = line.split('，');
    if (parts.length >= 2) {
      // 确保有足够的数据进行解析
      try {
        String person = parts[0].split('：')[1];
        String time = parts[1].split('：')[1]; // 假设时间戳为整数
        int type = getTypeFromDescription(line); // 获取类型
        String wave = getExtraFromDescription(line, parts);

        timelines
            .add(TimeLine(type: type, person: person, time: time, extra: wave));
      } catch (e) {
        // 可以在这里处理错误，例如解析错误
      }
    }
  }

  return timelines;
}

String parseOrderContent(String data) {
  String newOrderContent = normalizeNewlines(data);
  return newOrderContent;
}

// 一个辅助函数，用于根据行描述返回时间线对象的类型
int getTypeFromDescription(String description) {
  if (description.contains('打单')) {
    return 1;
  } else if (description.contains('配货')) {
    return 2;
  } else if (description.contains('对接收货')) {
    return 4;
  } else if (description.contains('拣货')) {
    return 4;
  } else if (description.contains('送货')) {
    return 5;
  } else if (description.contains('对接')) {
    return 3;
  }
  return 0; // 使用0作为未知类型的默认值
}

// 一个辅助函数，用于根据行描述返回时间线对象的类型 拣货人：管理员，加入波次3时间：2024-05-14 22:10:35
String getExtraFromDescription(String description, List<String> parts) {
  if (description.contains('拣货')) {
    String key = parts[1].split('：')[0];

    String wave = key.substring(0, key.length - 2);
    return wave;
  } else {
    return "";
  }
}

abstract class WaveDetailsScreen extends StatefulWidget {
  final Wave wave;

  // 正确的构造函数写法
  const WaveDetailsScreen({super.key, required this.wave});

  @override
  WaveDetailsScreenState createState(); // 确保有具体实现的子类
}

abstract class WaveDetailsScreenState extends State<WaveDetailsScreen> {
  late Wave _wave;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    print("init state");
    _wave = widget.wave; // 直接赋值，因为widget是在构造时已经传入的
    _fetchWaveDetails();
  }

  void _fetchWaveDetails() {
    // 这里假设将来可能会有异步获取详情的操作，目前设为同步
    setState(() {
      // 目前什么也不做，因为已经在 initState 中设置了 _wave，但可用于未来的异步操作
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildWaveDetailsScreen(context);
  }

  Widget buildWaveDetailsScreen(BuildContext context) {
    int? shipCount = widget.wave.shipCount;

    String showWaveInfo =
        "波次编号: ${_wave.waveId}，共计: ${_wave.addressCount}个地址，共计：${_wave.orderCount}个订单\n时间：${_wave.createTime}\n送货单数量：$shipCount";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 放置在SingleChildScrollView外面的Padding
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            showWaveInfo,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // SingleChildScrollView 包含剩余的可滚动内容
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ..._wave.addressOrders.map(
                  (addressSummary) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.green), // 地址图标
                            Expanded(
                                child: Text(
                              '${addressSummary.address} (共计${addressSummary.orders.length}个订单)',
                              style: Theme.of(context).textTheme.titleSmall,
                            ))
                          ],
                        ),
                        children:
                            addressSummary.orders.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var orderDetail = entry.value;
                          Color? bgColor = idx % 2 == 0
                              ? Colors.grey[200]
                              : Colors.white; // 偶数索引使用浅灰色, 奇数索引使用白色

                          String printTimeStr =
                              formatDatetime(orderDetail.createTime);
                          String curTimeStr =
                              formatDatetime(orderDetail.curTime);
                          String differenceTimeStr = formatTimeDifference(
                              orderDetail.createTime, orderDetail.curTime);

                          String content =
                              parseOrderContent(orderDetail.detail);

                          String orderIdStr = orderDetail.orderId.toString();

                          return Container(
                              color: bgColor,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(orderIdStr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                    Text(orderDetail.curStatus,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                    Row(
                                      children: [
                                        const Icon(Icons.hourglass_bottom,
                                            size: 20, color: Colors.blue),
                                        Text(differenceTimeStr),
                                      ],
                                    )
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('当前处理: $curTimeStr'),
                                    Text('打单时间: $printTimeStr'),
                                    const Center(
                                      child: Icon(Icons.shopping_bag,
                                          size: 20, color: Colors.blue),
                                    ),
                                    Text(content),
                                    // const Center(
                                    //   child: Icon(Icons.linear_scale_sharp,
                                    //       size: 14, color: Colors.blue),
                                    // ),
                                    // TimelineWidget(
                                    //   timelines:
                                    //       parseTimeLine(orderDetail.trace),
                                    // ),
                                  ],
                                ),
                                isThreeLine: true,
                              ));
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
        icon = Icons.checklist;
        label = '配货';
        break;
      case 3: // 对接
        icon = Icons.construction;
        label = '对接';
        break;
      case 4: // 拣货
        icon = Icons.assignment;
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
    return {
      'icon': icon,
      'label': label,
      'time': timeline.time,
      'person': timeline.person,
      'extra': timeline.extra
    };
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> eventWidgets = timelines.map((TimeLine timeline) {
      var mappedEvent = _mapEvent(timeline);
      // 根据时间和参与者是否存在来决定是否展示该行
      if (mappedEvent['time']?.isNotEmpty == true &&
          mappedEvent['person']?.isNotEmpty == true) {
        return Row(
          children: [
            Icon(
              mappedEvent['icon'] as IconData,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
                '${mappedEvent['label']} ${mappedEvent['person']} ${mappedEvent['time']} ${mappedEvent['extra']}'),
          ],
        );
      }
      return const SizedBox.shrink(); // 如果时间或参与者为空，则返回一个空的SizedBox
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
  String extra;

  TimeLine(
      {required this.type,
      required this.person,
      required this.time,
      required this.extra});
}
