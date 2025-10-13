part of 'p_create_post.dart';

class _SubmitButtonWidget extends StatelessWidget {
  const _SubmitButtonWidget({super.key});

  static const double _iconSize = 40;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return state.isSubmittable
            ? IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: state.isSubmittable
                    ? () async {
                        FocusScope.of(context).unfocus();
                        await context.read<CreatePostCubit>().submit();
                      }
                    : null,
                icon: state.status == ComposeStatus.idle
                    ? const Icon(Icons.arrow_forward, size: _iconSize)
                    : Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(),
                      ),
                tooltip: 'SUBMIT',
              )
            : const SizedBox.shrink();
      },
    );
  }
}
