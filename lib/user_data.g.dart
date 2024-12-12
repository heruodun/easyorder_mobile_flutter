// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      loginName: json['loginName'] as String,
      actualName: json['actualName'] as String,
      phone: json['phone'] as String,
      token: json['token'] as String,
      roleInfoList: (json['roleInfoList'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Role.fromJson(e as Map<String, dynamic>))
          .toList(), // Updated line,
      scanRuleList: (json['scanRuleList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'loginName': instance.loginName,
      'actualName': instance.actualName,
      'phone': instance.phone,
      'token': instance.token,
      'roleInfoList': instance.roleInfoList
          ?.map((e) => e?.toJson())
          .toList(), // Updated line
      'scanRuleList': instance.scanRuleList,
    };
