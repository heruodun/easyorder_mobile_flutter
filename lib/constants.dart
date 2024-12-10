import 'package:intl/intl.dart';

const httpHost = 'http://yangyi.ddns.net:1024';

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



// 计算时间差并格式化为 "X小时X分钟" 毫秒时间戳
  String formatTimeDifference(int start, int end) {
    final Duration diff = Duration(milliseconds: end - start);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '$hours小时$minutes分钟';
  }

