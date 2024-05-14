import 'package:intl/intl.dart';

const httpHost = 'http://yangyi.ddns.net:1024';
const httpHost2 = 'http://yangyi.ddns.net:5000';

const prefix4picker = "picker_";
const prefix4checker = "checker_";
const prefix4shipper = "shipper_";





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

