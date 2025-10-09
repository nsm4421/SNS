part of 'sign_up.page.dart';

class _UsernameTextFieldWidget extends StatefulWidget {
  const _UsernameTextFieldWidget(this._usernameController, {super.key});

  final TextEditingController _usernameController;

  @override
  State<_UsernameTextFieldWidget> createState() =>
      _UsernameTextFieldWidgetState();
}

class _UsernameTextFieldWidgetState extends State<_UsernameTextFieldWidget> {
  String? _availableUsername;
  String? _usernameErrorText;
  bool _checkUsernameDuplicatedButtonTappable = true;

  @override
  void initState() {
    super.initState();
    widget._usernameController.addListener(_handleUsernameChange);
  }

  @override
  void dispose() {
    super.dispose();
    widget._usernameController.removeListener(_handleUsernameChange);
  }

  void _handleUsernameChange() {
    setState(() {
      _usernameErrorText = null;
    });
  }

  String? _handleValidateUsername(String? text) {
    if (text == null || text.isEmpty) {
      return 'type username';
    } else if (text.length < 3 || text.length > 20) {
      return 'username should have 3~20 length';
    } else if (_availableUsername != text) {
      return 'check whether username is duplicated or not';
    }
    return null;
  }

  void _handleCheckUsername() async {
    final username = widget._usernameController.text.trim();
    if (username.length < 3 || username.length > 20) {
      setState(() {
        _usernameErrorText = 'username should have 3~20 length';
      });
      return;
    }
    setState(() {
      _checkUsernameDuplicatedButtonTappable = false;
    });
    await GetIt.instance<UserUseCases>().getIsUsernameDuplicated
        .call(username)
        .then(
          (res) => res.match(
            (l) {
              debugPrint(l.repr);
              _usernameErrorText = 'server error occurs';
              _availableUsername = null;
            },
            (isDuplicated) {
              if (isDuplicated) {
                debugPrint('duplicated username');
                _usernameErrorText = 'username is duplicated';
                _availableUsername = null;
              } else {
                debugPrint('username is available');
                _usernameErrorText = null;
                _availableUsername = username;
              }
            },
          ),
        );
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _checkUsernameDuplicatedButtonTappable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: !_checkUsernameDuplicatedButtonTappable,
      validator: _handleValidateUsername,
      keyboardType: TextInputType.name,
      controller: widget._usernameController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.text_fields_outlined),
        hintText: 'Username',
        errorText: _usernameErrorText,
        suffixIcon: _availableUsername == widget._usernameController.text.trim()
            ? const Icon(Icons.check_circle_outline)
            : (_checkUsernameDuplicatedButtonTappable
                  ? IconButton(
                      onPressed: _handleCheckUsername,
                      icon: const Icon(Icons.check),
                    )
                  : Transform.scale(
                      scale: 0.5,
                      child: const CircularProgressIndicator(),
                    )),
      ),
    );
  }
}
