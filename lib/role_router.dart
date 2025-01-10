import 'package:easyorder_mobile/constants.dart';
import 'package:easyorder_mobile/my.dart';
import 'package:easyorder_mobile/scan_assigner.dart';
import 'package:easyorder_mobile/scan.dart';
import 'package:easyorder_mobile/scan_general.dart';
import 'package:easyorder_mobile/user_role.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'scan_checker.dart';
import 'scan_shipper.dart';
import 'user_data.dart';
import 'wave_list.dart';

class MultiRoleScreen extends StatefulWidget {
  final User user;

  const MultiRoleScreen({super.key, required this.user});

  @override
  _MultiRoleScreenState createState() => _MultiRoleScreenState();
}

class _MultiRoleScreenState extends State<MultiRoleScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;
  late List<Role> roles;
  late List<Role> filteredRoles;

  @override
  void initState() {
    super.initState();
    // 初始化屏幕列表，基于角色
    roles = widget.user.roleInfoList!.cast<Role>();
    _screens = [];

    if (roles.any((role) => role.roleCode == peihuoRoleCode)) {
      ScanCheckerScreen checkerScreen = const ScanCheckerScreen();
      _screens.add(checkerScreen);
    }

    if (roles.any((role) => role.roleCode == fendanRoleCode)) {
      ScanAssignerScreen makerScreen = const ScanAssignerScreen();
      _screens.add(makerScreen);
    }

    if (roles.any((role) => role.roleCode == jianhuoRoleCode)) {
      _screens.add(WaveListScreen(user: widget.user));
    }

    if (roles.any((role) => role.roleCode == songhuoRoleCode)) {
      ScanShipperScreen shipperScreen = const ScanShipperScreen();
      _screens.add(shipperScreen);
    }

    //获取扫码类型角色
    filteredRoles = roles.where((role) => role.roleType == 1).toList();

    // 循环处理其他角色
    for (Role role in filteredRoles) {
      if (!inList(role.roleCode)) {
        // 如果角色代码不在常量列表中，则生成 ScanGeneralScreen
        ScanGeneralScreen otherScreen = ScanGeneralScreen(role: role);
        _screens.add(otherScreen);
      }
    }
    _screens.add(MyScreen(user: widget.user));
  }

  Future<void> _onSelect(int index, BottomNavigationBarItem item) async {
    // 启动当前选中屏幕的扫码器

    controller.start();
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Role> roles = widget.user.roleInfoList!.cast<Role>();
    // 动态创建 BottomNavigationBarItem 列表
    List<BottomNavigationBarItem> additionalItems = [];
    for (Role role in roles) {
      // 根据角色添加 BottomNavigationBarItem
      if (!inList(role.roleCode) && role.roleType == 1) {
        additionalItems.add(
          BottomNavigationBarItem(
              icon: getIconFromString(role.menuIcon), label: role.roleName),
        );
      }
    }
    // 使用RoleBasedNavBar组件作为底部导航
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: RoleBasedNavBar(
        roles: roles,
        itemsCheck: const [
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: '配货'),
        ],
        itemsMake: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind), label: '分单'),
        ],
        itemsPick: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '拣货'),
        ],
        itemsShip: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping), label: '送货'),
        ],
        itemsAdditional: additionalItems,
        itemsMy: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
        onSelect: _onSelect,
      ),
    );
  }
}
