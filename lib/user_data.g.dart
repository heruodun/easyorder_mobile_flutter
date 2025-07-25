// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      employeeId: (json['employeeId'] as num).toInt(),
      loginName: json['loginName'] as String,
      actualName: json['actualName'] as String,
      phone: json['phone'] as String,
      token: json['token'] as String,
      erpToken: json['erpToken'] as String?,
      roleInfoList: (json['roleInfoList'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      scanRuleList: (json['scanRuleList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      tenant: json['tenant'] == null
          ? null
          : Tenant.fromJson(json['tenant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'employeeId': instance.employeeId,
      'loginName': instance.loginName,
      'actualName': instance.actualName,
      'phone': instance.phone,
      'token': instance.token,
      'erpToken': instance.erpToken,
      'roleInfoList': instance.roleInfoList,
      'scanRuleList': instance.scanRuleList,
      'tenant': instance.tenant,
    };
