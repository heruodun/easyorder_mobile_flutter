import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'wave_list.dart';

//用户信息
class User {
  String? loginName;
  String? actualName;
  bool isLoggedIn;
  String? loginTime;

  // 这里我们使用命名构造器
  User({
    required this.loginName,
    required this.actualName,
    required this.isLoggedIn,
    this.loginTime,
  });

  // 假设你想构建成一个静态的方法
  static Future<User> getCurrentUser() async {
    // 确保WidgetsBinding已初始化。
    WidgetsFlutterBinding.ensureInitialized();
    // 获取实例
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // 获取存储的用户信息
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? loginName = prefs.getString('loginName'); // 使用默认值，防止null
    String? actualName = prefs.getString('actualName'); // 使用默认值，防止null
    String? loginTime = prefs.getString('loginTime');
    
    // 创建并返回用户对象
    return User(
      loginName: loginName,
      actualName: actualName,
      isLoggedIn: isLoggedIn,
      loginTime: loginTime,
    );
  }
}



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _login() async {

    int loginDevice = 6;
    if (!kIsWeb) {
      if(Platform.isAndroid){
        loginDevice = 2;
      }
      if(Platform.isIOS){
        loginDevice = 3;
      }
    }
    
    // // 这里应替换为对应的HTTP请求URL和登录逻辑
    var response = await http.post(
      Uri.parse('$httpHost/mobile/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'loginName': _usernameController.text,
        'password': _passwordController.text,
        'loginDevice': loginDevice.toString(),
      }),
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var data = jsonDecode(body);
      print(data);
      if (data['code'] == 0) {
        // 保存登录状态到本地
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('loginName', _usernameController.text);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('loginTime', DateTime.now().toIso8601String());
        await prefs.setString('actualName', data['data']['actualName']);
        // 跳转到WaveListScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WaveListScreen()),
        );
      } else {
        // 显示错误信息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['msg'])),
        );
      }
    } else {
      // 请求错误，显示错误信息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('网络请求出错')),
      );
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: '用户名',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('登录'),
            ),
          ],
        ),
      ),
    );
  }
}
