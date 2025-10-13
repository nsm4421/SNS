import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/presentation/provider/feed/create_post/create_post.cubit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 's_create_post.dart';

part 'f_content.dart';

part 'f_media.dart';

part 'w_submit_button.dart';

@RoutePage()
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CreatePostCubit>(),
      child: BlocListener<CreatePostCubit, CreatePostState>(
        listener: (context, state) async {
          switch (state.status) {
            case ComposeStatus.success:
              context.showSuccessSnackBar('Post Created!');
              if (!context.mounted || !context.router.canPop()) return;
              final postId = context.read<CreatePostCubit>().postId;
              debugPrint('created postId:$postId');
              context.router.pop<String>(postId);
            case ComposeStatus.failure:
              context.showErrorSnackBar(state.errorMessage ?? 'Error Occurs');
              await Future.delayed(const Duration(seconds: 1), () {
                context.read<CreatePostCubit>().initState();
              });
            default:
              return;
          }
        },
        child: const _CreatePostScreen(),
      ),
    );
  }
}
