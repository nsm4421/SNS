import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/usecase/usecase.export.dart';
import 'package:karma/presentation/component/component.export.dart';
import 'package:karma/presentation/provider/provider.export.dart';
import 'package:karma/presentation/router/app_router.dart';

part 'tab_menus.dart';

@RoutePage()
class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  static const double _appbarBottomHeight = 48;
  static const double _activeIconSize = 24;
  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance<DisplayPostsBloc>()),
      ],
      child: AutoTabsRouter(
        routes: _TabMenus.values
            .map(
              (menu) => switch (menu) {
                _TabMenus.home => const HomeTabRoute(),
                _TabMenus.feed => const FeedTabRoute(),
                _TabMenus.group => const GroupTabRoute(),
                _TabMenus.notification => const NotificationTabRoute(),
                _TabMenus.chat => const ChatTabRoute(),
                _TabMenus.setting => const SettingTabRoute(),
              },
            )
            .toList(),
        builder: (context, child) {
          final tabRouter = AutoTabsRouter.of(context);
          final currentTab = _TabMenus.values[tabRouter.activeIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text(currentTab.label),
              actions: switch (currentTab) {
                _TabMenus.home => [
                  IconButton(
                    onPressed: () {
                      // TODO : 그룹 만들기 페이지로 라우팅
                    },
                    icon: const Icon(Icons.add_circle_outline, size: _iconSize),
                    tooltip: 'Create Group',
                  ),
                ],

                _TabMenus.feed => [
                  IconButton(
                    onPressed: () async {
                      final String? createdPostId = await context.router.push(
                        const CreatePostRoute(),
                      );
                      if (createdPostId == null || !context.mounted) return;

                      await GetIt.instance<FeedUseCases>().getPost
                          .call(createdPostId)
                          .then(
                            (res) => res.match(
                              (l) {
                                debugPrint('getting created post fails');
                              },
                              (r) {
                                try {
                                  if (!context.mounted) return;
                                  context.read<DisplayPostsBloc>().add(
                                    DisplayEvent<
                                      FeedPostEntityWithAuthor
                                    >.upserted(r),
                                  );
                                } catch (e, st) {
                                  debugPrintStack(stackTrace: st);
                                }
                              },
                            ),
                          );
                    },
                    icon: const Icon(Icons.create_outlined, size: _iconSize),
                    tooltip: 'Create Feed',
                  ),
                ],

                _TabMenus.chat => [
                  IconButton(
                    onPressed: () {
                      // TODO : 대화상태 선택페이지로 라우팅
                    },
                    icon: const Icon(Icons.add_box_outlined, size: _iconSize),
                    tooltip: 'Create Chat',
                  ),
                ],

                _TabMenus.setting => [
                  IconButton(
                    onPressed: () {
                      context
                        ..read<AuthBloc>().add(
                          const AuthEvent.signOutRequested(),
                        )
                        ..router.replaceAll([const SignInRoute()]);
                    },
                    icon: const Icon(Icons.logout_outlined, size: _iconSize),
                    tooltip: 'Sign Out',
                  ),
                ],

                (_) => [],
              },

              bottom: PreferredSizedWidgetWrapper(
                height: _appbarBottomHeight,
                child: BottomNavigationBar(
                  currentIndex: tabRouter.activeIndex,
                  onTap: tabRouter.setActiveIndex,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 0,
                  items: _TabMenus.values
                      .map(
                        (e) => BottomNavigationBarItem(
                          icon: Icon(e.iconData, size: _iconSize),
                          activeIcon: Icon(
                            e.activeIconData,
                            size: _activeIconSize,
                          ),
                          label: e.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            body: child,
          );
        },
      ),
    );
  }
}
