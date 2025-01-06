import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final int id;
  final int orderId;
  final String address;
  final int? addressId;
  final List<Guige> guiges;
  final String? remark;
  final String detail;
  final List<Trace>? trace;
  final String curStatus;
  final DateTime curTime;
  final String curOperator;
  final int? curOperatorId;
  final String creator;
  final int creatorId;
  final int? waveId;
  final bool deletedFlag;
  final DateTime createTime;
  final DateTime updateTime;

  Order({
    required this.id,
    required this.orderId,
    required this.address,
    this.addressId,
    required this.guiges,
    this.remark,
    required this.detail,
    this.trace,
    required this.curStatus,
    required this.curTime,
    required this.curOperator,
    this.curOperatorId,
    required this.creator,
    required this.creatorId,
    this.waveId,
    required this.deletedFlag,
    required this.createTime,
    required this.updateTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class Guige {
  final String guige;
  final int count;
  final String danwei;
  final List<Tiao>? tiaos;

  Guige({
    required this.guige,
    required this.count,
    required this.danwei,
    this.tiaos,
  });

  factory Guige.fromJson(Map<String, dynamic> json) => _$GuigeFromJson(json);
  Map<String, dynamic> toJson() => _$GuigeToJson(this);
}

@JsonSerializable()
class Tiao {
  final String length;
  final int count;

  Tiao({
    required this.length,
    required this.count,
  });

  factory Tiao.fromJson(Map<String, dynamic> json) => _$TiaoFromJson(json);
  Map<String, dynamic> toJson() => _$TiaoToJson(this);
}

@JsonSerializable()
class Trace {
  final String operator;
  final String operation;
  final String time;
  final String? detail;

  Trace({
    required this.operator,
    required this.operation,
    required this.time,
    this.detail,
  });

  factory Trace.fromJson(Map<String, dynamic> json) => _$TraceFromJson(json);
  Map<String, dynamic> toJson() => _$TraceToJson(this);
}
