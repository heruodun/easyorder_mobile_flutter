import 'package:easyorder_mobile/order_data.dart';
import 'package:flutter/material.dart';

class TimelineWidget extends StatelessWidget {
  final List<Trace> traceList;

  TimelineWidget({super.key, required this.traceList});

  // Mock data
  final List<Trace> mockData = [
    Trace(
        operator: 'Alice',
        operation: 'Create',
        time: '2023-10-01 10:00',
        detail: 'Created a new file.'),
    Trace(
        operator: 'Bob',
        operation: 'Update',
        time: '2023-10-02 11:15',
        detail: 'Updated the document.'),
    Trace(
        operator: 'Charlie',
        operation: 'Delete',
        time: '2023-10-03 09:30',
        detail: 'Deleted an old version.'),
    Trace(
        operator: 'Dana',
        operation: 'Read',
        time: '2023-10-04 14:45',
        detail: 'Accessed the report.'),
    Trace(
        operator: 'Eve',
        operation: 'Share',
        time: '2023-10-05 08:00',
        detail: 'Shared the project with team.'),
  ];

  Color _getBackgroundColor(String operation) {
    switch (operation) {
      case '打单':
        return Colors.green[200]!;
      case 'Update':
        return Colors.blue[200]!;
      case 'Delete':
        return Colors.red[200]!;
      case 'Read':
        return Colors.orange[200]!;
      case 'Share':
        return Colors.purple[200]!;
      default:
        return Colors.blueGrey[600]!; // Fallback color
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can choose to display either the mock data or the passed traceList
    final displayList = traceList;

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        final trace = displayList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(
                color: _getBackgroundColor(trace.operation), width: 0.3),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: _getBackgroundColor(trace.operation),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    trace.operation,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 80, // 固定宽度
                  child: Text(
                    trace.operator,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 120, // 固定宽度
                  child: Text(
                    trace.time,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    // 对 detail 应用宽度限制
                    constraints: BoxConstraints(maxWidth: 200),
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
          ),
        );
      },
    );
  }
}
