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
      roleList: (json['roleList'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'loginName': instance.loginName,
      'actualName': instance.actualName,
      'phone': instance.phone,
      'token': instance.token,
      'roleList': instance.roleList,
    };
