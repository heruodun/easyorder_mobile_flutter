import 'package:easyorder_mobile/order_data.dart';
import 'package:flutter/material.dart';

class TimelineWidget extends StatelessWidget {
  final List<Trace> traceList;

  TimelineWidget({super.key, required this.traceList});

  Color _getBackgroundColor(String operation) {
    switch (operation) {
      case '送货':
        return Colors.green[200]!;
      case '拣货':
        return Colors.blue[200]!;
      case '打单':
        return Colors.red[200]!;
      case '配货':
        return Colors.orange[200]!;
      case '分单':
        return Colors.purple[200]!;
      default:
        return Colors.blueGrey[600]!; // Fallback color
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayList = traceList;
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 248, 245, 245),
              width: 1.0), // 外层边框颜色和宽度
          borderRadius: BorderRadius.circular(5.0), // 圆角边框
        ),
        child: Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: displayList.length,
            itemBuilder: (context, index) {
              final trace = displayList[index];
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: _getBackgroundColor(trace.operation),
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        trace.operation,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 5), // 设置固定宽度
                    Text(
                      trace.operator,
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5), // 设置固定宽度
                    Text(
                      trace.time,
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 5), // 设置固定宽度
                    Expanded(
                      child: Container(
                        // 对 detail 应用宽度限制
                        constraints: BoxConstraints(maxWidth: 200),
                        alignment: Alignment.centerRight,
                        child: Text(
                          trace.detail ?? '',
                          style: const TextStyle(color: Colors.black),
                          maxLines: 2, // 支持换行
                          overflow: TextOverflow.ellipsis, // 溢出处理
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
