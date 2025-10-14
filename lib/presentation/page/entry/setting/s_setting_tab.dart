part of 'p_setting_tab.dart';

class _SettingTabScreen extends StatelessWidget {
  const _SettingTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthBloc>().currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: context.read<AuthBloc>().currentUser != null
                  ? UserAvatarWidget(context.read<AuthBloc>().currentUser!)
                  : null,
              title: Text(currentUser!.username!),
              trailing: IconButton(
                onPressed: () async {
                  await context.router.push<AppUserEntity>(
                    const EditProfileRoute(),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
