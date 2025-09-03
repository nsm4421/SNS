part of 'create_feed.page.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, SimpleDataState<CreatePostData>>(
      builder: (context, state) {
        return IconButton(
          onPressed: state.status == Status.initial
              ? () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(microseconds: 100));
                  await context.read<CreateFeedCubit>().submit();
                }
              : null,
          icon: const Icon(Icons.add_box_outlined),
          tooltip: 'SUBMIT',
        );
      },
    );
  }
}
