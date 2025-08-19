part of 'sign_up.page.dart';

class SignUpSubmitButton extends StatelessWidget {
  const SignUpSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    const double size = 40;

    return BlocBuilder<SignUpCubit, SimpleDataState<SignUpData>>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            await Future.delayed(const Duration(microseconds: 100));
            FocusScope.of(context).unfocus();
            context.read<SignUpCubit>().submit();
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: state.status == Status.initial
                ? Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )
                : Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}
