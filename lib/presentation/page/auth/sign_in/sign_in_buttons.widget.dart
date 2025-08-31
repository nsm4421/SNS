part of 'sign_in.page.dart';

class SignInButtonsWidget extends StatelessWidget {
  const SignInButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInCubit, SimpleDataState<void>>(
      builder: (context, state) {
        final tappable = state.status == Status.initial;

        return Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer,
              ),
              onPressed: tappable
                  ? () async {
                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(microseconds: 100));
                      await context.read<SignInCubit>().submit();
                    }
                  : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("로그인")],
              ),
            ),
            const SizedBox(height: 8),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(
                  context,
                ).colorScheme.onSecondaryContainer,
              ),
              onPressed: tappable
                  ? () async {
                      await context.pushRoute(const SignUpRoute());
                    }
                  : null,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("회원가입")],
              ),
            ),
          ],
        );
      },
    );
  }
}
