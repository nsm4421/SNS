import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:karma/presentation/router/app_router.dart';

enum _HomeTabMenu {
  displayProfile(
    label: 'Users',
    iconData: Icons.people_outline,
    activeIconData: Icons.people,
    pageRoute: DisplayProfilesRoute(),
  ),
  displayDmRooms(
    label: 'DM',
    iconData: Icons.message_outlined,
    activeIconData: Icons.message,
    pageRoute: DisplayDmRoomsRoute(),
  ),
  displayNotifications(
    label: 'Alarm',
    iconData: Icons.notifications_outlined,
    activeIconData: Icons.notifications,
    pageRoute: DisplayNotificationsRoute(),
  ),
  setting(
    label: 'Setting',
    iconData: Icons.settings_outlined,
    activeIconData: Icons.settings,
    pageRoute: SettingRoute(),
  );

  final String label;
  final IconData iconData;
  final IconData activeIconData;
  final PageRouteInfo<void> pageRoute;

  const _HomeTabMenu({
    required this.label,
    required this.iconData,
    required this.activeIconData,
    required this.pageRoute,
  });
}

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: _HomeTabMenu.values.map((e) => e.pageRoute).toList(),
      builder: (context, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: AutoTabsRouter.of(context).activeIndex,
            onTap: AutoTabsRouter.of(context).setActiveIndex,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            elevation: 0,
            items: _HomeTabMenu.values
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(e.iconData),
                    activeIcon: Icon(e.activeIconData),
                    label: e.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
