import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/order_task.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/task_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import 'constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
  });

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  DateTime selectedDate = DateTime.now();
  List<Task> tasks = []; // 任务列表数据
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    fetchData(); // 获得初始化数据
  }

  void fetchData() {
    // 服务器返回的JSON响应会被转换成一个包含Wave对象的列表

    setState(() {
      tasks = [];
      _isCompleted = false;
    });

    fetchTasksByDate(selectedDate).then((data) {
      setState(() {
        tasks = data;
        _isCompleted = true;
        controller.stop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务列表'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 2), // 使用 Spacer 来推开右侧的 IconButton
              GestureDetector(
                onTap: () => _selectDate(context),
                onDoubleTap: () => _selectDate(context),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 40),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const Spacer(), // 使用 Spacer 来推开右侧的 IconButton
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 40,
                ),
                onPressed: () {
                  fetchData(); // 重新获取数据
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('共计${tasks.length}个任务',
                style: Theme.of(context).textTheme.titleSmall),
          ),
          Expanded(
            child: Stack(children: [
              ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(
                    task: tasks[index],
                    index: index, // 将索引传递给WaveItem
                    key: ValueKey(
                        tasks[index].id), // 使用waveId作为唯一key，如果waveId是唯一的话
                    totalCount: tasks[index].makeCount,
                  );
                },
              ),
              _buildResultLayer(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildResultLayer() {
    if (_isCompleted) {
      return const SizedBox.shrink(); // 如果不需要显示结果，返回一个空的小部件
    }

    return Center(
        child: LoadingAnimationWidget.horizontalRotatingDots(
      color: Colors.grey,
      size: 100,
    ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchData();
      });
    }
  }
}

class TaskItem extends StatefulWidget {
  final Task task;
  final int index; // 添加index参数
  final int totalCount;

  const TaskItem(
      {required this.task,
      required this.index,
      super.key,
      required this.totalCount});

  @override
  State<StatefulWidget> createState() => TaskItemScreenState();
}

class TaskItemScreenState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    int index = widget.index;
    String typeStr = task.type == 1 ? "全部做货" : "部分做货";

    return InkWell(
        onTap: () {
          // 点击时导航到波次详情页面
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrderPage(orderIdQr: '${task.orderId}\$xiaowangniujin'),
            ),
          );
        },
        child: ListTile(
            title: Text(
              '任务: ${task.id}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '全部${task.allCount}条,  $typeStr${task.makeCount}条',
                ),
                Text(
                  '${task.createTime}',
                ),
              ],
            ),
            leading: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.bodyMedium,
            ), // 显示从1开始的序号

            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(task.address,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),

              const SizedBox(width: 2), // 设置你想要的间距

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (task.status == 0) ...[
                    const Icon(
                      Icons.hourglass_empty,
                      color: Colors.blueGrey,
                    ),
                    Text(
                      '未开始',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else if (task.status == 10) ...[
                    const Icon(
                      Icons.radio_button_checked,
                      color: Colors.blue,
                    ),
                    Text(
                      '部分完成',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else if (task.status == 100) ...[
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text(
                      '已完成',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ] else ...[
                    const Icon(
                      Icons.help,
                      color: Colors.grey,
                    ),
                    Text(
                      ' 状态未知',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              )
            ])));
  }

  @override
  void initState() {
    super.initState();
  }
}

//-----------------------------------列表------------------------

Future<List<Task>> fetchTasksByDate(DateTime date) async {
  final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  final response = await httpClient(
      uri: Uri.parse('$httpHost/app/order/task/list?date=$formattedDate'),
      method: "GET");

  if (response.isSuccess) {
    List<dynamic> taskList = response.data; // Retrieve the list
    return taskList.map((taskJson) => Task.fromJson(taskJson)).toList();
  } else {
    throw Exception(response.message);
  }
}
