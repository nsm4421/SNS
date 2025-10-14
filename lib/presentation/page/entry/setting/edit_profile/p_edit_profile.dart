import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

part 's_edit_profile.dart';

@RoutePage()
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EditProfileScreen();
  }
}
