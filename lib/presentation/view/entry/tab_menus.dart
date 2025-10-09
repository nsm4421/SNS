part of 'entry.page.dart';

enum _TabMenus {
  home(
    label: 'Home',
    iconData: Icons.home_outlined,
    activeIconData: Icons.home,
  ),
  feed(
    label: 'Feed',
    iconData: Icons.feed_outlined,
    activeIconData: Icons.feed,
  ),
  group(
    label: 'Group',
    iconData: Icons.group_outlined,
    activeIconData: Icons.group,
  ),
  chat(
    label: 'Chat',
    iconData: Icons.chat_outlined,
    activeIconData: Icons.chat_bubble,
  ),
  notification(
    label: 'Notifications',
    iconData: Icons.notifications_outlined,
    activeIconData: Icons.notifications,
  ),
  setting(
    label: 'Setting',
    iconData: Icons.settings_outlined,
    activeIconData: Icons.settings,
  );

  final String label;
  final IconData iconData;
  final IconData activeIconData;

  const _TabMenus({
    required this.label,
    required this.iconData,
    required this.activeIconData,
  });
}
