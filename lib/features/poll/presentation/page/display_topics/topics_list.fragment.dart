import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns/core/util/bloc/simple_display_bloc.dart';
import 'package:sns/core/util/bloc/simple_display_event.dart';
import 'package:sns/features/poll/domain/entity/topic.entity.dart';
import 'package:sns/features/poll/presentation/bloc/display_topics/display_topics.bloc.dart';

class TopicsListFragment extends StatefulWidget {
  const TopicsListFragment({super.key});

  @override
  State<TopicsListFragment> createState() => _TopicsListFragmentState();
}

class _TopicsListFragmentState extends State<TopicsListFragment> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DisplayTopicBloc>().add(FetchDisplayDataEvent());
    }
  }

  Future<void> _onRefresh() async {
    context.read<DisplayTopicBloc>().add(RefreshDisplayEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayTopicBloc, SimpleDisplayState<TopicEntity>>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              final item = state.data[index];
              return ListTile(
                title: Text(
                  item.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  item.description,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
