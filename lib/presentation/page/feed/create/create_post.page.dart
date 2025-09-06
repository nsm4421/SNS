import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/extension/build_context.extension.dart';
import 'package:sns/presentation/provider/base/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/presentation/provider/feed/post/create_post.cubit.dart';

part 'create_post.screen.dart';

part 'feed_post.fragment.dart';

part 'select_image.fragment.dart';

part 'submit_button.widget.dart';

@RoutePage()
class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<CreateFeedCubit>(),
      child: BlocListener<CreateFeedCubit, SimpleDataState<CreatePostData>>(
        listener: (context, state) {
          if (state.status == Status.success) {
            context
              ..showSuccessSnackBar('피드 작성 성공')
              ..pop();
          } else if (state.status == Status.error) {
            context.showErrorSnackBar(state.errorMessage);
          }
        },
        child: const CreatePostScreen(),
      ),
    );
  }
}
