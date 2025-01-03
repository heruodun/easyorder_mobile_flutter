import 'package:easyorder_mobile/home2.dart';
import 'package:easyorder_mobile/home_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'bottom_nav_bar.dart';
import 'login.dart';
import 'role_router.dart';
import 'user_data.dart';
import 'package:provider/provider.dart';

// 0表示未打开 1表示打开
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User? user = await User
      .getCurrentUser(); // 假设getCurrentUser()返回Future<User?>或Future<User>

  Widget home = const LoginScreen();
  if (user != null) {
    home = Home2Page(user: user);
  }

  runApp(
    ChangeNotifierProvider(
        create: (_) => RoleManager(user!.roleInfoList![0]!),
        child: MyApp(home: home)),
  );
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: '小王牛筋',

      // 配置本地化
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: const Locale("zh"),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),

        // 定制文本主题
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary),
          titleLarge: TextStyle(
              fontSize: 18.0, color: Theme.of(context).colorScheme.primary),
          titleMedium: TextStyle(
              fontSize: 16.0, color: Theme.of(context).colorScheme.primary),
          titleSmall: TextStyle(
              fontSize: 14.0, color: Theme.of(context).colorScheme.primary),
          bodyLarge: TextStyle(
              fontSize: 14.0, color: Theme.of(context).colorScheme.primary),
          bodyMedium: TextStyle(
              fontSize: 12.0, color: Theme.of(context).colorScheme.primary),
          bodySmall: TextStyle(
              fontSize: 10.0, color: Theme.of(context).colorScheme.primary),
        ),

        // 定制图标主题
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),

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
