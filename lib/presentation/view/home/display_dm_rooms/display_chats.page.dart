import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:karma/domain/entity/chat/dm_room.entity.dart';
import 'package:karma/presentation/provider/chat/display_dm_rooms/display_dm_rooms.bloc.dart';
import 'package:karma/presentation/provider/display/display.bloc.dart';

part 'display_chats.screen.dart';

@RoutePage()
class DisplayDmRoomsPage extends StatelessWidget {
  const DisplayDmRoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GetIt.instance<DisplayDmRoomsBloc>()
            ..add(const DisplayEvent.started()),
      child: const DisplayDmRoomsScreen(),
    );
  }
}
