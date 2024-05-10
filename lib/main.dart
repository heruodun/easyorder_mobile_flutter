
import 'package:flutter/material.dart';

import 'login.dart';
import 'wave_list.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User? user = await User.getCurrentUser(); // 假设getCurrentUser()返回Future<User?>或Future<User>
  // 检查是否已登录，这里的逻辑可以根据你的需求来调整
  bool isLoggedIn = user?.isLoggedIn ?? false;
  Widget home = (!isLoggedIn || 
                 user?.loginName == null || 
                 user.loginName!.isEmpty) 
      ? LoginScreen() // 如果任何一个条件不满足，则显示登录页面
      : WaveListScreen(); // 如果全部存在，直接跳转
  runApp(MyApp(home: home));
}


class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大航',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),

        // 定制文本主题
        textTheme:  TextTheme(
          displayLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
          bodyLarge: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.primary),
          bodyMedium: TextStyle(fontSize: 14.0, color: Theme.of(context).colorScheme.primary),
        ),

        // 定制图标主题
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary
        ),

        // 自定义AppBar主题
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        useMaterial3: true,

      ),
      home: home, // 使用了确定的启动界面
    );
  }
}
