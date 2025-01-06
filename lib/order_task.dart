import 'package:easyorder_mobile/mock.dart';
import 'package:easyorder_mobile/order.dart';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderPage extends StatefulWidget {
  final String orderId;

  const OrderPage({super.key, required this.orderId});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Order? _order;
  late List<User> allUsers;
  bool _isPartial = false;
  int _makeCount = 0;
  List<int> _doCounts = [];

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
    _fetchOrder();
  }

  Future<void> _fetchAllUsers() async {
    allUsers = getUsers();
  }

  Future<void> _fetchOrder() async {
    setState(() {
      _order = get();
      _doCounts = List.filled(_order!.guiges[0].tiaos!.length, 0);
    });
  }

  void _calculateMakeCount() {
    if (_isPartial) {
      _makeCount = _doCounts.reduce((a, b) => a + b);
    } else {
      _makeCount = _order!.guiges[0].count;
    }
  }

  void _submitOrder() async {
    if (_order == null) return;

    final response = await http.post(
      Uri.parse('https://yourapi.com/orders/submit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'order_id': _order!.orderId,
        'type': _isPartial ? 1 : 0,
        'address': _order!.address,
        'guige': _order!.guiges[0].guige,
        'make_count': _makeCount,
        'all_count': _order!.guiges[0].count,
        'sub_tasks': _getSubTasks(),
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
    }
  }

  List<Map<String, dynamic>> _getSubTasks() {
    return List.generate(_order!.guiges[0].tiaos!.length, (i) {
      return {
        // 'length': _order!.guiges[0].tiaos![i].length,
        // 'count': _doCounts[i],
        // 'user_id': _userIds.length > i ? _userIds[i] : null,
        // 'user_name': _username,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('做货分配')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_order != null) ...[
              Text(_order!.address,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
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
                        style: const TextStyle(color: Colors.red)),
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
                              Icon(Icons.all_inclusive),
                              SizedBox(width: 4),
                              Text('全部做货')
                            ])),
                        Tab(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text('部分做货'),
                              SizedBox(width: 4),
                              Icon(Icons.party_mode)
                            ])),
                      ],
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.grey,
                      onTap: (index) {
                        setState(() {
                          _isPartial = index == 1;
                          _calculateMakeCount();
                        });
                      },
                    ),
                    SizedBox(
                      height: 350,
                      child: TabBarView(children: [
                        ListView.builder(
                          itemCount: _order!.guiges[0].tiaos!.length,
                          itemBuilder: (context, index) {
                            return _buildPartialView(index);
                          },
                        ),
                        ListView.builder(
                          itemCount: _order!.guiges[0].tiaos!.length,
                          itemBuilder: (context, index) {
                            return ItemWidget(
                              allUsers: allUsers,
                              count: _order!.guiges[0].tiaos![index].count,
                              length: _order!.guiges[0].tiaos![index].length,
                              index: index,
                              // Pass the order data here
                              onCountChanged: (count) {
                                setState(() {
                                  _doCounts[index] = count;
                                  _calculateMakeCount();
                                });
                              },
                              doCount: null,
                              doUsers: const [],
                            );
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Text('总计做货: $_makeCount ${_order!.guiges[0].danwei}'),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.assignment),
                label: const Text('分配任务', style: TextStyle(fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPartialView(int index) {
    return Column(
      children: [
        Text(
            '${_order!.guiges[0].tiaos![index].length}, ${_order!.guiges[0].tiaos![index].count}'),
        TextField(
          decoration: const InputDecoration(labelText: 'Do Count'),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _doCounts[index] = int.tryParse(value) ?? 0;
              _calculateMakeCount();
            });
          },
        ),
      ],
    );
  }
}

class ItemWidget extends StatefulWidget {
  final int count;
  final int? doCount;
  final String length;
  final int index;
  final List<User>? doUsers;
  final List<User> allUsers; //所有做货工人
  final ValueChanged<int> onCountChanged;

  const ItemWidget({
    super.key,
    required this.count,
    required this.length,
    required this.index,
    required this.onCountChanged,
    required this.allUsers,
    required this.doCount,
    required this.doUsers,
  });

  @override
  State<StatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  final TextEditingController _controller = TextEditingController();

  int doCount = 0;
  List<User> doUsers = [];

  @override
  void initState() {
    super.initState();
    if (widget.doCount == null) {
      doCount = 0;
    } else {
      doCount = widget.doCount!;
    }
    doUsers = widget.doUsers!;
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
            crossAxisAlignment: CrossAxisAlignment.center, // 文本和用户列表居中对齐
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.length} X ${widget.count}条 ',
                      style: const TextStyle(
                        fontSize: 18, // 字体大小放大
                        color: Colors.black, // 确保文本颜色
                      ),
                    ),
                    TextSpan(
                      text: '$doCount',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18, // 字体大小放大
                      ),
                    ),
                    const TextSpan(
                      text: '条',
                      style: TextStyle(
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
                child: Row(
                  children: doUsers
                      .map((user) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0), // 用户间的间隔
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0), // 每个用户的框的内边距
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey), // 用户框的边框颜色
                              borderRadius:
                                  BorderRadius.circular(4.0), // 每个框的圆角
                            ),
                            child: Text(user.actualName), // 用户名
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _showEditDialog(widget.index);
              },
            ),
          ],
        ),
      ],
    );
  }

  List<bool> getChecks(List<User> doUsers) {
    List<User> allUsers = widget.allUsers;
    return allUsers.map((allUser) {
      return doUsers.any((doUser) => doUser.loginName == allUser.loginName);
    }).toList();
  }

  List<User> getUsers(List<bool> checkList) {
    // 确保checkList的长度与allUsers的长度一致
    if (checkList.length != widget.allUsers.length) {
      throw ArgumentError('checkList must have the same length as allUsers');
    }
    List<User> selectedUsers = [];
    // 遍历checkList，收集被选中的用户
    for (int i = 0; i < checkList.length; i++) {
      if (checkList[i]) {
        selectedUsers.add(widget.allUsers[i]);
      }
    }
    return selectedUsers;
  }

  Future<void> _showEditDialog(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        List<bool> tempCheckList =
            getChecks(doUsers); // Make a copy for the dialog
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title: Text('做货分配 ${widget.length} X ${widget.count}条'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: '做货数量'),
                        ),
                        const SizedBox(height: 16),
                        const Text('选择工人:'),
                        Wrap(
                          spacing: 2.0, // 水平间距
                          runSpacing: 2.0, // 垂直间距
                          children: List.generate(widget.allUsers.length, (i) {
                            return SizedBox(
                              width: 80, // 设置每个 checkbox 的宽度，以控制每行放多少个
                              child: CheckboxListTile(
                                title: SizedBox(
                                  width: 40, // 这里可以根据需要调整宽度
                                  child: Text(widget.allUsers[i].actualName),
                                ),
                                value: tempCheckList[i], // 使用副本
                                onChanged: (bool? value) {
                                  setState(() {
                                    tempCheckList[i] =
                                        value ?? false; // 更新副本并调用 setState
                                  });
                                },
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        int count = int.tryParse(_controller.text) ?? 0;
                        List<User> users = getUsers(tempCheckList);
                        setState(() {
                          _updateDoCountAndUsers(
                              count, users); // use updated checkList
                          widget.onCountChanged(count);
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('确认'),
                    ),
                  ],
                ));
      },
    );
  }

  void _updateDoCountAndUsers(int count, List<User> users) {
    setState(() {
      doUsers = users;
      doCount = count;
    });
  }
}
