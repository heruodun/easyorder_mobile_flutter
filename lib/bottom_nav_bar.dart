// import 'package:easyorder_mobile/constants.dart';
// import 'package:easyorder_mobile/scan_general.dart';
// import 'package:easyorder_mobile/user_role.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class RoleBasedNavBar extends StatefulWidget {
//   final List<Role> roles;
//   // final List<RoleBottomNavigationBarItem> itemsCheck;
//   // final List<RoleBottomNavigationBarItem> itemsMake;
//   final BottomNavigationBarItem itemsPick;
//   final BottomNavigationBarItem itemsShip;
//   final BottomNavigationBarItem itemsMy;
//   final List<BottomNavigationBarItem> itemsAdditional;
//   final Function(int, BottomNavigationBarItem) onSelect;

//   const RoleBasedNavBar({
//     super.key,
//     required this.roles,
//     // required this.itemsCheck,
//     // required this.itemsMake,
//     required this.itemsPick,
//     required this.itemsShip,
//     required this.itemsMy,
//     required this.itemsAdditional,
//     required this.onSelect,
//   });

//   @override
//   State<RoleBasedNavBar> createState() => _RoleBasedNavBarState();
// }

// class _RoleBasedNavBarState extends State<RoleBasedNavBar> {
//   int _selectedIndex = 0;
//   List<BottomNavigationBarItem> navBarItems =
//       []; // We'll build this list dynamically

//   @override
//   void initState() {
//     super.initState();

//     if (widget.roles.any((role) => role.roleCode == songhuoRoleCode)) {
//       navBarItems.add(widget.itemsShip);
//     }

//     if (widget.roles.any((role) => role.roleCode == jianhuoRoleCode)) {
//       navBarItems.add(widget.itemsPick);
//     }

//     navBarItems.addAll(widget.itemsAdditional);

//     navBarItems.add(widget.itemsMy);

//     // 只在组件初始化时设置这些值
//     final provider =
//         Provider.of<BottomNavigationBarProvider>(context, listen: false);
//     provider.currentIndex = 0; // 或根据需要设置
//     provider.currentLabel = navBarItems[provider.currentIndex].label!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<BottomNavigationBarProvider>(context);

//     // Populate `_navBarItems` based on roles
//     // Note: The order of roles here will dictate the order in which they appear in the nav bar.
//     // For example, if 'peihuo' should come before 'duijie', ensure it's added first.

//     // add other roles similarly...

//     // Now, when onTap is called, simply pass the index to the widget.onSelect callback.
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed, // 将类型设置为固定
//       backgroundColor: Colors.white, // 设置导航栏背景颜色，可按需调整
//       selectedItemColor: Theme.of(context).primaryColor, // 被选中项的颜色
//       unselectedItemColor: Colors.grey, // 未选中项的颜色

//       items: navBarItems,
//       currentIndex: _selectedIndex,
//       onTap: (index) {
//         provider.currentIndex = index;
//         provider.currentLabel = navBarItems[index].label!;

//         setState(() {
//           _selectedIndex = index;
//         });
//         widget.onSelect(
//             index, navBarItems[index]); // Call the unified onSelect callback
//       },
//     );
//   }
// }

// class BottomNavigationBarProvider with ChangeNotifier {
//   int _currentIndex = 0;
//   String _currentLabel = "";

//   int get currentIndex => _currentIndex;

//   set currentIndex(int index) {
//     _currentIndex = index;
//     notifyListeners();
//   }

//   String get currentLabel => _currentLabel;

//   set currentLabel(String label) {
//     _currentLabel = label;
//     notifyListeners();
//   }
// }
