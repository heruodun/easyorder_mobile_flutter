import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpResponseModel {
  final int statusCode;
  final dynamic data;
  final String message;
  final bool isSuccess; // 新增的字段

  HttpResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.isSuccess, // 修改构造函数以接收这个参数
  });
}

Future<HttpResponseModel> httpClient({
  required Uri uri,
  required dynamic body,
  required String method,
}) async {
  late http.Response response;

  try {
    if (method.toUpperCase() == 'POST') {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );
    } else if (method.toUpperCase() == 'GET') {
      response = await http.get(uri);
    } else if (method.toUpperCase() == 'PUT') {
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );
    } else if (method.toUpperCase() == 'DELETE') {
      response = await http.delete(uri);
    }
    else {
      throw Exception('Unsupported HTTP method');
    }

    final Map<String, dynamic> responseBody = json.decode(utf8.decode(response.bodyBytes));

    bool isSuccess = response.statusCode == 200 && responseBody['code'] == 0;

    return HttpResponseModel(
      statusCode: response.statusCode,
      data: isSuccess ? responseBody['data'] : null,
      message: responseBody['msg'],
      isSuccess: isSuccess, // 设置 isSuccess 字段
    );
  } catch (e) {
    // 处理网络请求异常
    return HttpResponseModel(
      statusCode: 500,
      data: null,
      message: '网络异常',
      isSuccess: false, // 异常时设置为 false
    );
  }
}

