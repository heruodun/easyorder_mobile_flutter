import 'package:flutter/material.dart';

import 'login.dart';
import 'user_data.dart';

class MyScreen extends StatelessWidget {
   final User user;
  const MyScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
         actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('登出'),
              ),
            ],
          )
        ]
      ),
      body:  Center(
        child: Text('我的姓名：${user.actualName}', style: TextStyle(fontSize: 24)),
      ),
      // You can also include other widgets like FloatingActionButton if needed
    );
  }


     // 处理PopupMenuButton选项的选中事件
  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        logout(context);
        break;
      // 其他case...
    }
  }
}