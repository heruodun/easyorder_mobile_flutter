import 'package:easyorder_mobile/constants.dart';
import 'package:easyorder_mobile/http_client.dart';
import 'package:easyorder_mobile/order_data.dart';
import 'package:easyorder_mobile/order_task_item.dart';
import 'package:easyorder_mobile/order_task_list.dart';
import 'package:easyorder_mobile/task_data.dart';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class OrderPage extends StatefulWidget {
  final String orderIdQr;

  const OrderPage({super.key, required this.orderIdQr});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Order? _order;
  Task? _task;
  List<User> allUsers = [];
  int _makeCount = 0;
  Map<String, int> _doCountsMap = {};
  Map<String, List<SubTask>> orderSubTaskMap = {};
  bool _isCompleted = false;
  // bool _isSwitched = false; // Switch的状态

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    setState(() {});

    _isCompleted = false;

    allUsers = await getAllMakers();
    OrderTask orderTask = await fetchTaskByOrderIdQr(widget.orderIdQr);

    setState(() {
      _order = orderTask.order;
      _task = orderTask.task;
      orderSubTaskMap = buildOrderSubTaskMap(orderTask);
      _doCountsMap = buildDoCountsMap(orderSubTaskMap);
      _makeCount = totalCount(_doCountsMap);
      // _index = orderTask.task?.type == 1 ? 0 : 1;
    });
    _isCompleted = true;
  }

  int totalCount(Map<String, int> doCountsMap) {
    int count = 0;
    doCountsMap.forEach((mark, value) {
      count += value;
    });
    return count;
  }

  // void _toggleSwitch(bool value) {
  //   String tip = value ? '切换到绑定成功' : '切换到不绑定成功';
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //         content: Text(
  //           tip,
  //         ),
  //         backgroundColor: Colors.green),
  //   );
  //   setState(() {
  //     _isSwitched = value; // 更新状态
  //   });
  // }

  Map<String, int> buildDoCountsMap(
      Map<String, List<SubTask>> orderSubTaskMap) {
    Map<String, int> doCountsMap = {};

    // 遍历 orderSubTaskMap 的每个键值对
    orderSubTaskMap.forEach((orderId, subTasks) {
      int totalCount = 0;

      // 如果 subTasks 不是空，计算 count 的总和
      if (subTasks.isNotEmpty) {
        for (var subTask in subTasks) {
          totalCount += subTask.count;
        }
      }

      // 将计算的总和添加至 doCountsMap
      doCountsMap[orderId] = totalCount;
    });

    return doCountsMap;
  }

  Map<String, List<SubTask>> buildOrderSubTaskMap(OrderTask orderTask) {
    // 创建一个空的 Map 用于存放分组结果
    Map<String, List<SubTask>> orderSubTaskMap = {};

    // 获取与订单相关的任务
    Task? task = orderTask.task;

    // 检查task是否存在以及task的subTasks是否存在
    if (task != null && task.subTasks != null) {
      for (SubTask subTask in task.subTasks!) {
        // 检查mark字段是否不为空和不为空字符串
        if (subTask.mark.isNotEmpty) {
          // 如果map中已经存在该mark，则添加subTask到对应的列表中
          if (!orderSubTaskMap.containsKey(subTask.mark)) {
            orderSubTaskMap[subTask.mark] = [];
          }
          orderSubTaskMap[subTask.mark]!.add(subTask);
        }
      }
    }

    // 返回构建好的map
    return orderSubTaskMap;
  }

  void _calculateMakeCount() {
    _makeCount = _doCountsMap.values.fold(0, (a, b) => a + b);
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

  Widget _buildTaskLayer(BuildContext context) {
    return Column(
      children: [
        if (_order != null) ...[
          Text(_order!.address,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('${_order!.orderId}', style: const TextStyle(fontSize: 14)),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              children: [
                TextSpan(text: '${_order!.guiges[0].guige} '),
                TextSpan(
                    text: '${_order!.guiges[0].count} ',
                    style: const TextStyle(color: Colors.blue)),
                TextSpan(text: _order!.guiges[0].danwei),
              ],
            ),
          ),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: const [
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Icon(Icons.circle),
                          SizedBox(width: 4),
                          Text('全部做货')
                        ])),
                    Tab(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text('部分做货'),
                          SizedBox(width: 4),
                          Icon(Icons.pie_chart)
                        ])),
                  ],
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.blueGrey,
                  onTap: (index) async {
                    fetchData();
                    setState(() {
                      _calculateMakeCount();
                    });
                  },
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(children: [
                    ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2.0), // 为每个元素添加上下间距
                            decoration: BoxDecoration(
                                // color: Colors.white, // 元素背景色
                                borderRadius: BorderRadius.circular(8.0), // 圆角
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 245, 241, 241))),
                            child: ItemWidget(
                              task: _task,
                              type: 1,
                              orderId: _order!.orderId,
                              allUsers: allUsers,
                              count: _order!.guiges[0].count,
                              mark: _order!.guiges[0].guige,
                              orderSubTasks:
                                  orderSubTaskMap[_order!.guiges[0].guige] ??
                                      [],
                              index: index,
                              // Pass the order data here
                              onCountChanged: (count) {
                                fetchData();
                                setState(() {
                                  _doCountsMap[_order!.guiges[0].guige] = count;
                                  _calculateMakeCount();
                                });
                              },
                              doCount: _doCountsMap[
                                  _order!.guiges[0].guige], // 传递当前计数
                            ));
                      },
                    ),
                    ListView.builder(
                      itemCount: _order!.guiges[0].tiaos!.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2.0), // 为每个元素添加上下间距
                            decoration: BoxDecoration(
                                // color: Colors.white, // 元素背景色
                                borderRadius: BorderRadius.circular(8.0), // 圆角
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 245, 241, 241))),
                            child: ItemWidget(
                              task: _task,
                              type: 0,
                              orderId: _order!.orderId,
                              allUsers: allUsers,
                              count: _order!.guiges[0].tiaos![index].count,
                              mark: _order!.guiges[0].tiaos![index].length,
                              orderSubTasks: orderSubTaskMap[
                                      _order!.guiges[0].tiaos![index].length] ??
                                  [],
                              index: index,
                              // Pass the order data here
                              onCountChanged: (count) {
                                fetchData();
                                setState(() {
                                  _doCountsMap[_order!
                                      .guiges[0].tiaos![index].length] = count;
                                  _calculateMakeCount();
                                });
                              },
                              doCount: _doCountsMap[_order!
                                  .guiges[0].tiaos![index].length], // 传递当前计数
                            ));
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),

          // Center(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Switch(
          //         value: _isSwitched, // 当前状态
          //         onChanged: _toggleSwitch, // 状态改变时的回调
          //         activeColor: Colors.green, // Switch被激活时的颜色
          //       ),
          //       const SizedBox(width: 10), // 用于调整Switch与文本之间的间距
          //       Text(_isSwitched ? '已绑定' : '未绑定',
          //           style: const TextStyle(
          //               color: Colors.redAccent,
          //               fontSize: 25,
          //               fontWeight: FontWeight.bold)), // 文本显示状态
          //     ],
          //   ),
          // ),

          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(text: '总计做货：'),
                TextSpan(
                    text: '$_makeCount ',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(text: _order!.guiges[0].danwei),
              ],
            ),
          ),

          Text(_getStatusText(_task),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.blue, // 根据需要设置颜色
                fontWeight: FontWeight.bold, // 根据需要设置样式
              )),
        ],
      ],
    );
  }

  // 定义一个方法来返回状态文本
  String _getStatusText(Task? task) {
    if (task == null) {
      return '未分单'; // 根据情况添加自定义文本
    }
    if (task.status == 0) {
      return '未开始'; // 根据情况添加自定义文本
    } else if (task.status == 10) {
      return '部分完成';
    } else if (task.status == 100) {
      return '已完成';
    } else {
      return '未分单';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('做货分配'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              // 点击按钮时导航到 ListPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            _buildTaskLayer(context),
            _buildResultLayer(), // Add the loading layer on top
          ],
        ),
      ),
    );
  }
}

//------------------------------http-------------------------------
Future<OrderTask> fetchTaskByOrderIdQr(String orderIdQr) async {
  final response = await httpClient(
      uri: Uri.parse('$httpHost/app/order/task?orderIdQr=$orderIdQr'),
      method: "GET");

  if (response.isSuccess) {
    return OrderTask.fromJson(response.data);
  } else {
    throw Exception(response.message);
  }
}

Future<void> deleteSubTasks(String orderIdQr, int type) async {
  final response = await httpClient(
    uri: Uri.parse(
        '$httpHost/app/order/task/delete?orderIdQr=$orderIdQr&type=$type'),
    method: "GET",
  );

  if (response.isSuccess) {}
}

Future<List<User>> getAllMakers() async {
  final response = await httpClient(
    uri: Uri.parse(
        '$httpHost/app/role/employee/getAllEmployeeByRoleCode/duijie'),
    method: "GET",
  );

  if (response.isSuccess) {
    // Assuming response.data is a List
    List<dynamic> userList = response.data; // Retrieve the list
    return userList
        .where((userJson) => userJson != null) // 过滤掉空值
        .map((userJson) => User.fromJson(userJson))
        .toList();
    // Parse each user and return a list
  } else {
    throw Exception(response.message);
  }
}
