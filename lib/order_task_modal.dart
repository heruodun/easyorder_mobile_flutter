import 'package:easyorder_mobile/constants.dart';
import 'package:easyorder_mobile/width_height_grid.dart';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/task_data.dart';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserInputWidget extends StatefulWidget {
  final User user;
  final SubTask orderSubTask;
  final int maxCount;
  final Function(int) onCountChanged;

  const UserInputWidget(
      {required this.user,
      required this.orderSubTask,
      required this.onCountChanged,
      required this.maxCount});

  @override
  _UserInputWidgetState createState() => _UserInputWidgetState();
}

class _UserInputWidgetState extends State<UserInputWidget> {
  late TextEditingController countController;

  @override
  void initState() {
    super.initState();
    countController = TextEditingController(
        text: widget.orderSubTask.count == 0
            ? ''
            : widget.orderSubTask.count.toString());
    countController.addListener(() {
      int count = int.tryParse(countController.text) ?? 0;
      widget.onCountChanged(count);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isCountPositive = widget.orderSubTask.count > 0; // Flag to check count
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                countController.text = '${widget.maxCount}'; // 设置文本为100
                countController.selection = TextSelection.fromPosition(
                    TextPosition(
                        offset: countController.text.length)); // 将光标移到末尾
              });
            },
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  widget.user.actualName,
                  style: TextStyle(
                    fontSize: 18,
                    color: isCountPositive ? Colors.red : Colors.black,
                    fontWeight:
                        isCountPositive ? FontWeight.bold : FontWeight.normal,
                  ),
                ))),
        const SizedBox(height: 2),
        TextField(
          controller: countController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isCollapsed: true,
            alignLabelWithHint: true,
            labelStyle: TextStyle(),
            // contentPadding: EdgeInsets.symmetric(
            //     vertical: 0, horizontal: 0), // 调整内边距以减小高度
            // contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // 只允许输入数字
            LengthLimitingTextInputFormatter(10), // 限制输入长度，可以根据需要调整
          ],
          onChanged: (value) {
            if (value.isNotEmpty) {
              final number = int.tryParse(value);
              if (number != null && number <= 0) {
                countController.text = '0'; // 如果输入小于等于0，则自动改回1
                countController.selection = TextSelection.fromPosition(
                    TextPosition(
                        offset: countController.text.length)); // 将光标移到末尾
              }
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    countController.dispose();
    super.dispose();
  }
}

extension OrderSubTaskExtension on SubTask {
  SubTask copyWith({int? count}) {
    return SubTask(
      id: id,
      taskId: taskId,
      userId: userId,
      orderId: orderId,
      userName: userName,
      mark: mark,
      type: type,
      count: count ?? this.count,
      status: status,
      createTime: createTime,
      updateTime: updateTime,
    );
  }
}

class BottomModalSheet extends StatefulWidget {
  final List<User> users;
  final List<SubTask>? orderSubTasks;
  final int orderId;
  final Function(List<SubTask>, int) onSubmit;
  final int maxCount;
  final int type;
  final String mark;

  const BottomModalSheet(
      {super.key,
      required this.users,
      this.orderSubTasks,
      required this.onSubmit,
      required this.maxCount,
      required this.orderId,
      required this.type,
      required this.mark});

  @override
  _BottomModalSheetState createState() => _BottomModalSheetState();
}

class _BottomModalSheetState extends State<BottomModalSheet> {
  List<SubTask> orderTasksList = [];
  int tempCount = 0;

  @override
  void initState() {
    super.initState();

    SubTask createSubTask(User user) {
      return SubTask(
        id: 0,
        taskId: 0,
        userId: user.employeeId,
        orderId: widget.orderId,
        userName: user.actualName,
        mark: widget.mark,
        count: 0,
        status: 0,
        type: widget.type,
        createTime: DateTime.now(),
        updateTime: DateTime.now(),
      );
    }

    orderTasksList = widget.users.map((user) {
      // 使用 `firstWhere` 找到匹配的任务，如果没有找到则使用 `createSubTask` 返回新的任务
      return widget.orderSubTasks?.firstWhere(
            (task) =>
                task.userId == user.employeeId && task.type == widget.type,
            orElse: () => createSubTask(user), // 返回一个新的 SubTask
          ) ??
          createSubTask(user); // 如果 orderSubTasks 是 null，也调用 createSubTask
    }).toList();
    updateTempCount();
  }

  void updateTempCount() {
    int newTempCount = orderTasksList.fold(0, (sum, task) => sum + task.count);
    setState(() {
      tempCount = newTempCount;
    });
    // if (tempCount > widget.maxCount) {
    //   Fluttertoast.showToast(
    //     msg: '做货数量$tempCount条，超过最大值${widget.maxCount}条',
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.TOP,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    int remain = widget.maxCount - tempCount;
    return Container(
      padding: const EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // 点击取消按钮时，关闭BottomModalSheet
                  Navigator.pop(context);
                },
                child: const Text('取消'),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${widget.mark} x ${widget.maxCount} 条',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    if (tempCount > widget.maxCount) {
                      Fluttertoast.showToast(
                        msg: '做货数量$tempCount超过最大值${widget.maxCount}',
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                      );
                      return; // Prevent submission
                    }
                    Map<int, SubTask> uniqueTasksMap = {};

                    for (var task in orderTasksList) {
                      if (task.count >= 0) {
                        uniqueTasksMap[task.userId] = task; // 根据 userId 去重
                      }
                    }
                    List<SubTask> tasksToSubmit =
                        uniqueTasksMap.values.toList();

                    int total =
                        tasksToSubmit.fold(0, (sum, task) => sum + task.count);
                    await submitData(tasksToSubmit, total);
                  },
                  label: const Text(
                    "提交",
                  )),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: ' 当前 ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$tempCount',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' 条',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const TextSpan(
                  text: ' 剩余可做 ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$remain',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: ' 条',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            height: 1, // 分割线的高度
            color: const Color.fromARGB(255, 231, 228, 222), // 分割线的颜色
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(3),
              gridDelegate: SliverGridDelegateWithFixedSize(70, 60,
                  mainAxisSpacing: 1, minCrossAxisSpacing: 1),
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                return UserInputWidget(
                  maxCount: widget.maxCount,
                  user: widget.users[index],
                  orderSubTask: orderTasksList[index],
                  onCountChanged: (count) {
                    orderTasksList[index] =
                        orderTasksList[index].copyWith(count: count);
                    updateTempCount();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitData(List<SubTask> lists, int total) async {
    final response = await httpClient(
      uri: Uri.parse('$httpHost/app/order/task/add'),
      body: {'subTasks': lists},
      method: "POST",
      context: context,
    );

    if (response.isSuccess) {
      // 更新内部状态，关闭对话框
      List<SubTask> validSubTasks =
          lists.where((subTask) => subTask.count > 0).toList();
      widget.onSubmit(validSubTasks, total);

      Navigator.pop(context); // Close the modal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
              '更新成功',
            ),
            backgroundColor: Colors.green),
      );
    } else {
      String msg = response.message;
      // 处理错误情况
      Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
