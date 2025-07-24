import 'package:easyorder_mobile/order_task_modal.dart';
import 'package:easyorder_mobile/task_data.dart';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  final dynamic orderId;
  //订单上的数量
  final int count;
  //订单上的长度或者规格
  final String mark;
  final String danwei;
  final int? doCount;
  //第几个元素
  final int index;
  //做货子任务列表
  final List<SubTask>? orderSubTasks;
  final Task? task;
  final List<User> allUsers; //所有做货工人

  final ValueChanged<int> onCountChanged;
  final int type;

  const ItemWidget(
      {super.key,
      required this.count,
      required this.mark,
      required this.danwei,
      required this.index,
      required this.onCountChanged,
      required this.allUsers,
      required this.doCount,
      this.orderSubTasks,
      required this.orderId,
      required this.type,
      this.task});

  @override
  State<StatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  List<SubTask> submittedTasks = [];
  int totalCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize totalCount
    totalCount = widget.doCount ?? 0;

    // Check if widget.orderSubTasks is null and initialize accordingly
    submittedTasks = widget.orderSubTasks ?? [];

    debugPrint('_ItemWidgetState initState');
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: BottomModalSheet(
            mark: widget.mark,
            type: widget.type,
            orderId: widget.orderId,
            maxCount: widget.count,
            danwei: widget.danwei,
            users: widget.allUsers,
            orderSubTasks: widget.orderSubTasks,
            onSubmit: (submittedList, total) {
              setState(() {
                submittedTasks = submittedList;
                totalCount = total;
                widget.onCountChanged(totalCount); // 调用回调
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // 使用 spaceBetween 将内容均匀分布
      children: [
        Expanded(
          // 使用 Expanded 可以让内容占用剩余空间
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 文本和用户列表居中对齐
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${widget.mark} x ${widget.count} ${widget.danwei} ',
                      style: const TextStyle(
                        fontSize: 18, // 字体大小放大
                        color: Colors.black, // 确保文本颜色
                      ),
                    ),
                    TextSpan(
                      text: '$totalCount',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18, // 字体大小放大
                      ),
                    ),
                    TextSpan(
                      text: ' ${widget.danwei} ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18, // 字体大小放大
                      ),
                    ),
                  ],
                ),
              ),

              // 用户列表
              Container(
                padding: const EdgeInsets.all(5.0), // 内边距
                child: Wrap(
                  spacing: 5.0, // 用户间的间隔
                  runSpacing: 5.0, // 行与行之间的间隔
                  children: submittedTasks.map((subTask) {
                    Color backgroundColor;
                    Color textColor;
                    BoxBorder border;

                    // 根据 subTask.status 的值来设置背景色和字体颜色
                    if (subTask.status == 0) {
                      backgroundColor = Colors.transparent; // 无背景色
                      textColor = Colors.black; // 默认字体颜色
                      border = Border.all(color: Colors.grey);
                    } else if (subTask.status == 100) {
                      backgroundColor = Colors.green; // 背景色为绿色
                      textColor = Colors.white; // 字体为白色
                      border = Border.all(color: Colors.green);
                    } else {
                      backgroundColor = Colors.grey; // 可以选择其他颜色标识其他状态
                      textColor = Colors.black; // 默认字体颜色
                      border = Border.all(color: Colors.grey);
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: backgroundColor, // 设置背景色
                        border: border,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        '${subTask.userName}  ${subTask.count}',
                        style: TextStyle(
                          fontSize: 14, // 字体大小放大
                          color: textColor, // 根据状态设置文本颜色
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // 根据条件决定是否显示 IconButton
        if (widget.task == null || widget.task!.status <= 0)
          // || (submittedTasks.isEmpty || !submittedTasks.any((task) => task.status > 0))
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  openBottomSheet();
                },
              ),
            ],
          ),
      ],
    );
  }
}
