import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/extension/datetime.extension.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/domain/entity/feed/post_comment.entity.dart';
import 'package:sns/presentation/component/expandable_text.widget.dart';
import 'package:sns/presentation/component/network_image_carousel.widget.dart';
import 'package:sns/presentation/provider/auth/authentication/authentication.bloc.dart';
import 'package:sns/presentation/provider/base/simple_data_cubit/simple_data.cubit.dart';
import 'package:sns/presentation/provider/base/simple_display_bloc/simple_display.bloc.dart';
import 'package:sns/presentation/provider/feed/comment/create_parent_post_comment.cubit.dart';
import 'package:sns/presentation/provider/feed/comment/display_post_comments.bloc.dart';
import 'package:sns/presentation/provider/feed/post/display_posts.bloc.dart';
import 'package:sns/presentation/provider/feed/like/like_post.cubit.dart';
import 'package:sns/presentation/router/app_router.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'display_posts.screen.dart';

part 'comment/post_comment.screen.dart';

part 'feed_item.widget.dart';

part 'like/like_icon.widget.dart';

part 'comment/comment_text_field.dart';

part 'comment/display_comments.fragment.dart';

part 'comment/comment_icon.widget.dart';

@RoutePage()
class DisplayPostsPage extends StatelessWidget {
  const DisplayPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayPostsBloc>()..add(RefreshDisplayEvent()),
      child: const DisplayPostsScreen(),
    );
  }
}
