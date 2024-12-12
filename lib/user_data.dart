import 'dart:convert';

import 'package:easyorder_mobile/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_data.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "loginName")
  String loginName;
  @JsonKey(name: "actualName")
  String actualName;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "token")
  String token;
  @JsonKey(name: "roleInfoList")
  List<Role?>? roleInfoList; // Updated line
  @JsonKey(name: "scanRuleList")
  List<String?>? scanRuleList;

  User({
    required this.loginName,
    required this.actualName,
    required this.phone,
    required this.token,
    required this.roleInfoList,
    required this.scanRuleList,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static Future<User?> getCurrentUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserInfo = prefs.getString('current_user_login_info');
    if (currentUserInfo == null) {
      return null;
    }
    // 正确的从JSON字符串转换为Map对象
    print("cur user is $currentUserInfo");
    Map<String, dynamic> userMap = json.decode(currentUserInfo);
    return User.fromJson(userMap);
  }

  static Future<void> saveCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 正确的把User对象转换为JSON字符串进行存储
    String userInfoString = json.encode(user.toJson());
    await prefs.setString('current_user_login_info', userInfoString);
  }

  static Future<void> delCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 正确的把User对象转换为JSON字符串进行存储
    await prefs.remove('current_user_login_info');
  }
}
