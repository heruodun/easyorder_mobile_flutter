import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Tenant {
  @JsonKey(name: "tenantId")
  int tenantId;
  @JsonKey(name: "loginName")
  String loginName;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "tag")
  String tag;

  Tenant({
    required this.tenantId,
    required this.loginName,
    required this.type,
    required this.tag,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  Map<String, dynamic> toJson() => _$TenantToJson(this);
}

// JSON 反序列化和序列化代码
Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      tenantId: json['tenantId'] as int,
      loginName: json['loginName'] as String,
      type: json['type'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'tenantId': instance.tenantId,
      'loginName': instance.loginName,
      'type': instance.type,
      'tag': instance.tag,
    };
