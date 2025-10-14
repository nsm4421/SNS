part of 'p_edit_profile.dart';

class _EditProfileScreen extends StatefulWidget {
  const _EditProfileScreen({super.key});

  @override
  State<_EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<_EditProfileScreen> {
  late final TextEditingController _usernameController;

  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: const SingleChildScrollView(
        child: Column(children: [Text('TEST')]),
      ),
    );
  }
}
