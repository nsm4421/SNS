part of 'app_router.dart';

enum AppRoutes {
  signIn('/sign-in'),
  signUp('/sign-up');

  final String path;

  const AppRoutes(this.path);
}
