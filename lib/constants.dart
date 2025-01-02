import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const httpHost = 'http://yangyi.ddns.net:1024';
// const httpHost = 'http://192.168.1.88:1024';

// 配货
const prefix4checker = "checker_";

// 做货
const prefix4maker = "maker_";

// 拣货
const prefix4picker = "picker_";

// 送货
const prefix4shipper = "shipper_";

//配货
const int operationCheck = 100;

//对接
const int operationAlign = 200;

//做货
const int operationMake = 300;

//拣货
const int operationPick = 400;

//送货
const int operationShip = 500;

const String peihuoRoleCode = "peihuo";
const String duijieRoleCode = "duijie";
const String jianhuoRoleCode = "jianhuo";
const String songhuoRoleCode = "songhuo";

bool inList(String roleCode) {
  const List<String> validRoleCodes = [
    jianhuoRoleCode,
    songhuoRoleCode,
  ];

  return validRoleCodes.contains(roleCode);
}

String normalizeNewlines(String input) {
  // 使用正则表达式匹配连续的两个换行符，并将其替换为一个换行符。
  return input.replaceAll(RegExp(r'\n\n'), '\n');
}

// 使用前面给出的formatTimestamp函数
String formatTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(date);
}

String formatDatetime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(dateTime);
}

// 计算时间差并格式化为 "X小时X分钟" 毫秒时间戳
String formatTimeDifference(DateTime start, DateTime end) {
  final Duration diff = end.difference(start);
  final hours = diff.inHours;
  final minutes = diff.inMinutes % 60;
  return '$hours小时$minutes分钟';
}

Icon getIconFromString(String iconName) {
  switch (iconName) {
    case 'qr_code':
      return const Icon(Icons.qr_code);
    case 'shopping_bag':
      return const Icon(Icons.shopping_bag);
    case 'content_cut':
      return const Icon(Icons.content_cut);
    case 'book':
      return const Icon(Icons.book);
    case 'print':
      return const Icon(Icons.print);
    case 'scale':
      return const Icon(Icons.scale);
    case 'join_inner':
      return const Icon(Icons.join_inner);
    case 'signal_cellular_0_bar':
      return const Icon(Icons.signal_cellular_0_bar);
    case 'trip_origin':
      return const Icon(Icons.trip_origin);
    case 'moped':
      return const Icon(Icons.moped);
    case 'card_travel':
      return const Icon(Icons.card_travel);
    case 'nat':
      return const Icon(Icons.nat);
    case 'grid_on':
      return const Icon(Icons.grid_on);
    case 'camera':
      return const Icon(Icons.qr_code);
    case 'access_alarm':
      return const Icon(Icons.access_alarm);
    case 'back_hand':
      return const Icon(Icons.back_hand);
    case 'cable':
      return const Icon(Icons.cable);

    default:
      return const Icon(Icons.photo_camera);
  }
}
