enum AppRoutes {
  signIn('$authPrefix/sign-in', isEntry: true),
  signUp('$authPrefix/sign-up'),
  entry('/topic/display'),
  createTopic('/topic/create'),
  topicDetail('/topic/detail'),
  settings('/settings');

  final String path;
  final bool isEntry;

  static const authPrefix = '/auth';

  const AppRoutes(this.path, {this.isEntry = false});
}
