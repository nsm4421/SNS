import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sns/core/constant/bottom_nav.constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this._shell, {super.key});

  final StatefulNavigationShell _shell;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBottomNavVisible = true;
  int _currentBottomNavIndex = 0;

  _handleBottomNavVisibility(bool isVisible) {
    setState(() {
      _isBottomNavVisible = isVisible;
    });
  }

  _handleTapBottomNav(int index) {
    widget._shell.goBranch(index);
    setState(() {
      _currentBottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget._shell,
      bottomNavigationBar: _isBottomNavVisible
          ? BottomNavigationBar(
              elevation: 0,
              currentIndex: _currentBottomNavIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              items: BottomNavMenu.values
                  .map(
                    (e) => BottomNavigationBarItem(
                      label: e.label,
                      icon: Icon(e.iconData),
                      activeIcon: Icon(e.activeIconData),
                    ),
                  )
                  .toList(),
              onTap: _handleTapBottomNav,
            )
          : null,
    );
  }
}
