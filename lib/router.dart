  
  
import 'package:flutter/material.dart';

import 'login.dart';
import 'scan_shipper.dart';
import 'user_data.dart';
import 'wave_list.dart';

Widget mainWidget(User? user){
    if(user == null){
      return LoginScreen();
    }

    Widget home = LoginScreen();
 // 基于角色不同跳转到不同的Screen
    String role = user.roleList![0]!;

    if(role == "jianhuo"){
      home = WaveListScreen();
    }
    else if(role == "songhuo"){
      home = ScanShipperScreen();
    }
    else if(role == "peihuo"){
      
    }
    return home;
  }