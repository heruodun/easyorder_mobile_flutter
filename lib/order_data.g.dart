// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num).toInt(),
      orderId: (json['orderId'] as num).toInt(),
      address: json['address'] as String,
      addressId: (json['addressId'] as num?)?.toInt(),
      guiges: (json['guiges'] as List<dynamic>)
          .map((e) => Guige.fromJson(e as Map<String, dynamic>))
          .toList(),
      remark: json['remark'] as String?,
      detail: json['detail'] as String?,
      trace: (json['trace'] as List<dynamic>?)
          ?.map((e) => Trace.fromJson(e as Map<String, dynamic>))
          .toList(),
      curStatus: json['curStatus'] as String,
      curTime: DateTime.parse(json['curTime'] as String),
      curOperator: json['curOperator'] as String,
      curOperatorId: (json['curOperatorId'] as num?)?.toInt(),
      creator: json['creator'] as String,
      creatorId: (json['creatorId'] as num).toInt(),
      waveId: (json['waveId'] as num?)?.toInt(),
      deletedFlag: json['deletedFlag'] as bool,
      createTime: DateTime.parse(json['createTime'] as String),
      updateTime: DateTime.parse(json['updateTime'] as String),
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'address': instance.address,
      'addressId': instance.addressId,
      'guiges': instance.guiges,
      'remark': instance.remark,
      'detail': instance.detail,
      'trace': instance.trace,
      'curStatus': instance.curStatus,
      'curTime': instance.curTime.toIso8601String(),
      'curOperator': instance.curOperator,
      'curOperatorId': instance.curOperatorId,
      'creator': instance.creator,
      'creatorId': instance.creatorId,
      'waveId': instance.waveId,
      'deletedFlag': instance.deletedFlag,
      'createTime': instance.createTime.toIso8601String(),
      'updateTime': instance.updateTime.toIso8601String(),
    };

Guige _$GuigeFromJson(Map<String, dynamic> json) => Guige(
      guige: json['guige'] as String,
      count: (json['count'] as num).toInt(),
      danwei: json['danwei'] as String,
      tiaos: (json['tiaos'] as List<dynamic>?)
          ?.map((e) => Tiao.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GuigeToJson(Guige instance) => <String, dynamic>{
      'guige': instance.guige,
      'count': instance.count,
      'danwei': instance.danwei,
      'tiaos': instance.tiaos,
    };

Tiao _$TiaoFromJson(Map<String, dynamic> json) => Tiao(
      length: json['length'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TiaoToJson(Tiao instance) => <String, dynamic>{
      'length': instance.length,
      'count': instance.count,
    };

Trace _$TraceFromJson(Map<String, dynamic> json) => Trace(
      operator: json['operator'] as String,
      operation: json['operation'] as String,
      time: json['time'] as String,
      detail: json['detail'] as String?,
    );

Map<String, dynamic> _$TraceToJson(Trace instance) => <String, dynamic>{
      'operator': instance.operator,
      'operation': instance.operation,
      'time': instance.time,
      'detail': instance.detail,
    };
