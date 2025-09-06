import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sns/presentation/router/app_router.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [DisplayPostsRoute(), DisplayReelsRoute(), SettingRoute()],
      transitionBuilder: (context, child, animation) =>
          FadeTransition(opacity: animation, child: child),
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            showUnselectedLabels: false,
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Feed',
                icon: Icon(Icons.photo_album_outlined),
                activeIcon: Icon(Icons.photo_album),
              ),
              BottomNavigationBarItem(
                label: 'Reels',
                icon: Icon(Icons.video_collection_outlined),
                activeIcon: Icon(Icons.video_collection),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
              ),
            ],
          ),
        );
      },
    );
  }
}
