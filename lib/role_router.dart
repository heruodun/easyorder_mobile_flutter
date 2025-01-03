// import 'package:easyorder_mobile/constants.dart';
// import 'package:easyorder_mobile/my.dart';
// import 'package:easyorder_mobile/scan.dart';
// import 'package:easyorder_mobile/scan_general.dart';
// import 'package:easyorder_mobile/scan_shipper.dart';
// import 'package:easyorder_mobile/user_role.dart';
// import 'package:easyorder_mobile/wave_list.dart';
// import 'package:flutter/material.dart';
// import 'bottom_nav_bar.dart';
// import 'user_data.dart';

// class MultiRoleScreen extends StatefulWidget {
//   final User user;

//   const MultiRoleScreen({super.key, required this.user});

//   @override
//   _MultiRoleScreenState createState() => _MultiRoleScreenState();
// }

// class _MultiRoleScreenState extends State<MultiRoleScreen> {
//   int _currentIndex = 0;
//   late List<Widget> _screens;
//   late List<Role> filteredRoles;
//   late List<Role> itemRoles = [];

//   @override
//   void initState() {
//     super.initState();
//     List<Role> roles = widget.user.roleInfoList!.cast<Role>();

//     bool hasSonghuo = false;

//     _screens = [];

//     for (Role role in roles) {
//       if (role.roleCode == jianhuoRoleCode) {
//         _screens.add(WaveListScreen(user: widget.user));
//         itemRoles.add(role);
//       }

//       if (role.roleCode == songhuoRoleCode) {
//         _screens.add(const ScanShipperScreen());
//         itemRoles.add(role);
//         hasSonghuo = true;
//       }
//     }

//     // //获取扫码类型角色
//     filteredRoles = roles.where((role) => role.roleType == 1).toList();

// // 循环处理其他角色
//     for (int i = 0; i < filteredRoles.length; i++) {
//       Role role = filteredRoles[i];
//       if (!inList(role.roleCode) && !hasSonghuo) {
//         // 如果角色代码不在常量列表中，则生成 ScanGeneralScreen
//         ScanGeneralScreen otherScreen = ScanGeneralScreen();
//         _screens.add(otherScreen);
//         break;
//       }
//     }

//     itemRoles.addAll(filteredRoles);

//     _screens.add(MyScreen(user: widget.user));
//   }

//   Future<void> _onSelect(int index, BottomNavigationBarItem item) async {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Role> roles = widget.user.roleInfoList!.cast<Role>();

//     // 动态创建 BottomNavigationBarItem 列表
//     List<BottomNavigationBarItem> additionalItems = [];
//     for (Role role in roles) {
//       // 根据角色添加 BottomNavigationBarItem
//       if (!inList(role.roleCode) && role.roleType == 1) {
//         additionalItems.add(
//           BottomNavigationBarItem(
//               icon: getIconFromString(role.menuIcon), label: role.roleName),
//         );
//         break;
//       }
//     }
//     // 使用RoleBasedNavBar组件作为底部导航
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: RoleBasedNavBar(
//         roles: roles,
//         itemsPick: const BottomNavigationBarItem(
//             icon: Icon(Icons.assignment), label: '拣货'),
//         itemsShip: const BottomNavigationBarItem(
//             icon: Icon(Icons.local_shipping), label: '送货'),
//         itemsAdditional: additionalItems,
//         itemsMy: const BottomNavigationBarItem(
//             icon: Icon(Icons.person), label: '我的'),
//         onSelect: _onSelect,
//       ),
//     );
//   }
// }
