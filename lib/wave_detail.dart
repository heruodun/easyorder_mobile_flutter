import 'package:easyorder_mobile/constants.dart';
import 'package:easyorder_mobile/timeline.dart';
import 'package:flutter/material.dart';
import 'wave_data.dart';

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

                          String content = orderDetail.detail ?? '';

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
                                    const Center(
                                      child: Icon(Icons.timeline,
                                          size: 20, color: Colors.blue),
                                    ),
                                    SizedBox(
                                      height:
                                          150, // Set a fixed height for the TimelineWidget
                                      child: TimelineWidget(
                                          traceList: orderDetail.trace ?? []),
                                    )
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
