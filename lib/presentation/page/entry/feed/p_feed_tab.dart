import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/presentation/component/component.export.dart';
import 'package:karma/presentation/provider/provider.export.dart';

part 's_feed_tab.dart';

part 's_feed_comment.dart';

part 'w_feed_item.dart';

part 'w_comment_icon.dart';

part 'w_like_icon.dart';

@RoutePage()
class FeedTabPage extends StatelessWidget {
  const FeedTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<DisplayPostsBloc>().add(
      const DisplayEvent<FeedPostEntityWithAuthor>.started(),
    );
    return const _FeedTabScreen();
  }
}
