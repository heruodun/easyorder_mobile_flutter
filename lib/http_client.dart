import 'dart:convert';
import 'package:easyorder_mobile/error.dart';
import 'package:easyorder_mobile/login.dart';
import 'package:easyorder_mobile/user_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpResponseModel {
  final int statusCode;
  final int code;
  final dynamic data;
  final String message;
  final bool isSuccess; // 新增的字段

  HttpResponseModel({
    required this.code,
    required this.statusCode,
    required this.data,
    required this.message,
    required this.isSuccess, // 修改构造函数以接收这个参数
  });
}

Future<HttpResponseModel> httpClient({
  required Uri uri,
  dynamic body,
  required String method,
  required BuildContext context,
}) async {
  late http.Response response;
  User? user = await User.getCurrentUser();

  try {
    if (method.toUpperCase() == 'POST') {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Access-Token': user!.token
        },
        body: json.encode(body),
      );
    } else if (method.toUpperCase() == 'GET') {
      response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Access-Token': user!.token
        },
      );
    } else if (method.toUpperCase() == 'PUT') {
      response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Access-Token': user!.token
        },
        body: json.encode(body),
      );
    } else if (method.toUpperCase() == 'DELETE') {
      response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Access-Token': user!.token
        },
      );
    } else {
      throw Exception('Unsupported HTTP method');
    }

    final Map<String, dynamic> responseBody =
        json.decode(utf8.decode(response.bodyBytes));

    // 添加处理401的逻辑
    if (response.statusCode == 200 && responseBody['code'] == 401) {
      _showLoginPrompt(context);
      return HttpResponseModel(
        statusCode: response.statusCode,
        data: null,
        message: '登录失效，请重新登录',
        code: 401,
        isSuccess: false,
      );
    }

    bool isSuccess = response.statusCode == 200 && responseBody['code'] == 0;

    // Handling all non-200 status codes
    if (response.statusCode != 200 || responseBody['code'] != 0) {
      _navigateToErrorPage(context, responseBody['msg'] ?? '未知错误');
      return HttpResponseModel(
        statusCode: response.statusCode,
        data: null,
        message: responseBody['msg'] ?? '未知错误',
        code: responseBody['code'] ?? -1,
        isSuccess: false,
      );
    }

    return HttpResponseModel(
      statusCode: response.statusCode,
      data: responseBody['data'],
      message: responseBody['msg'],
      code: responseBody['code'],
      isSuccess: isSuccess, // 设置 isSuccess 字段
    );
  } catch (e) {
    // 处理网络请求异常
    return HttpResponseModel(
      statusCode: 500,
      code: -1,
      data: null,
      message: '网络异常',
      isSuccess: false, // 异常时设置为 false
    );
  }
}

void _showLoginPrompt(BuildContext context) {
  // 直接导航到登录页面
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}

void _navigateToErrorPage(BuildContext context, String errorMessage) {
  // 导航到错误页面，并传递错误信息
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => ErrorPage(message: errorMessage)),
  );
}
