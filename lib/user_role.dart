import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Role {
  @JsonKey(name: "roleCode")
  String roleCode;

  @JsonKey(name: "roleName")
  String roleName;
// 1 扫码类型角色
  @JsonKey(name: "roleType")
  int roleType;
  @JsonKey(name: "menuIcon")
  String menuIcon;

  Role({
    required this.roleCode,
    required this.roleName,
    required this.roleType,
    required this.menuIcon,
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

// JSON 反序列化和序列化代码
Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      roleCode: json['roleCode'] as String,
      roleName: json['roleName'] as String,
      roleType: json['roleType'] as int,
      menuIcon: json['menuIcon'] as String,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'roleCode': instance.roleCode,
      'roleName': instance.roleName,
      'roleType': instance.roleType,
      'menuIcon': instance.menuIcon,
    };
