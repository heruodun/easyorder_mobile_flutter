import 'package:flutter/material.dart';

class RoleBasedNavBar extends StatefulWidget {
  final List<String> roles;
  final List<BottomNavigationBarItem> itemsCheck;
  final List<BottomNavigationBarItem> itemsMake;
  final List<BottomNavigationBarItem> itemsPick;
  final List<BottomNavigationBarItem> itemsShip;
  final List<BottomNavigationBarItem> itemsMy;
  final Function(int, BottomNavigationBarItem) onSelect;

  const RoleBasedNavBar({
    super.key,
    required this.roles,
    required this.itemsCheck,
    required this.itemsMake,
    required this.itemsPick,
    required this.itemsShip,
    required this.itemsMy,
    required this.onSelect,
  });

  @override
  State<RoleBasedNavBar> createState() => _RoleBasedNavBarState();
}

class _RoleBasedNavBarState extends State<RoleBasedNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }



@override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navBarItems = []; // We'll build this list dynamically

    // Populate `_navBarItems` based on roles
    // Note: The order of roles here will dictate the order in which they appear in the nav bar.
    // For example, if 'peihuo' should come before 'duijie', ensure it's added first.
    if (widget.roles.contains("peihuo")) {
      navBarItems.addAll(widget.itemsCheck);
    }
    if (widget.roles.contains("duijie")) {
      navBarItems.addAll(widget.itemsMake);
    }

    if (widget.roles.contains("jianhuo")) {
      navBarItems.addAll(widget.itemsPick);
    }

    if (widget.roles.contains("songhuo")) {
      navBarItems.addAll(widget.itemsShip);
    }

    navBarItems.addAll(widget.itemsMy);
    // add other roles similarly...
    
    // Now, when onTap is called, simply pass the index to the widget.onSelect callback.
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 将类型设置为固定
         backgroundColor: Colors.white, // 设置导航栏背景颜色，可按需调整
        selectedItemColor: Theme.of(context).primaryColor, // 被选中项的颜色
        unselectedItemColor: Colors.grey, // 未选中项的颜色

      items: navBarItems,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onSelect(index, navBarItems[index]); // Call the unified onSelect callback
      },
    );
  }
}
