enum AppRoutes {
  signIn('$authPrefix/sign-in', isEntry: true),
  signUp('$authPrefix/sign-up'),
  home('/home'),
  createTopic('/topic/create'),
  displayTopics('/topic/display'),
  topicDetail('/topic/detail');

  final String path;
  final bool isEntry;

  static const authPrefix = '/auth';

  const AppRoutes(this.path, {this.isEntry = false});
}
