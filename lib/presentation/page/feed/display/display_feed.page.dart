import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sns/domain/entity/feed/post.entity.dart';
import 'package:sns/presentation/provider/base/simple_display_bloc/simple_display.bloc.dart';
import 'package:sns/presentation/provider/feed/display/display_post.bloc.dart';
import 'package:sns/presentation/provider/feed/like/like_post.cubit.dart';
import 'package:sns/presentation/router/app_router.dart';

part 'display_feed.screen.dart';

part 'feed_list.fragment.dart';

part 'feed_item.widget.dart';

part 'feed_image_carousel.widget.dart';

part 'like_post_icon.widget.dart';

@RoutePage()
class DisplayFeedPage extends StatelessWidget {
  const DisplayFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayPostBloc>()..add(RefreshDisplayEvent()),
      child: const DisplayFeedScreen(),
    );
  }
}
