part of 'sign_up.page.dart';

class SignUpSubmitButton extends StatelessWidget {
  const SignUpSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SignUpCubit, SimpleDataState<SignUpData>>(
      builder: (context, state) {
        final tappable = state.status == Status.initial;

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          onPressed: tappable
              ? () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(Duration(microseconds: 100));
                  await context.read<SignUpCubit>().submit();
                }
              : null,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("회원가입")],
          ),
        );
      },
    );
  }
}
