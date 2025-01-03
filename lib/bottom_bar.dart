import 'package:easyorder_mobile/user_role.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Role> itemRoles;

  BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.itemRoles,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // 确保底部导航栏为固定类型
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue, // 选中项的颜色
      unselectedItemColor: Colors.black54, // 未选中项的颜色
      items: List.generate(itemRoles.length + 1, (index) {
        if (index < itemRoles.length) {
          return BottomNavigationBarItem(
            icon: const Icon(Icons.camera),
            label: itemRoles[index].roleName,
          );
        } else {
          return const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "我的",
          );
        }
      }),
    );
  }
}
