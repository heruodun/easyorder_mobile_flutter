import 'package:easyorder_mobile/my.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart';
import 'scan_checker.dart';
import 'scan_maker.dart';
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

  @override
  void initState() {
    super.initState();
    // 初始化屏幕列表，基于角色
    List<String> roles = widget.user.roleList!.cast<String>();

    _screens = [];

    if(roles.contains("peihuo")){
      _screens.add( const ScanCheckerScreen());
    }

    if(roles.contains("duijie")){
      _screens.add (const ScanMakerScreen());
    }

    if(roles.contains("jianhuo")){
       _screens.add (WaveListScreen(user: widget.user));
    }

    if(roles.contains("songhuo")){
      _screens.add( const ScanShipperScreen());
    }

    _screens.add( MyScreen(user: widget.user));

  }

  void _onSelect(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> roles = widget.user.roleList!.cast<String>();
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
          BottomNavigationBarItem(icon: Icon(Icons.construction), label: '对接'),
        ],
          itemsPick: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: '拣货'),
        ],
        itemsShip: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: '送货'),
        ], 
        itemsMy: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ], 
        onSelect: _onSelect,
      ),
    );
  }
}
