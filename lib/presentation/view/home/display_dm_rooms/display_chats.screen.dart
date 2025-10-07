part of 'display_chats.page.dart';

class DisplayDmRoomsScreen extends StatelessWidget {
  const DisplayDmRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DisplayDmRoomsBloc, DisplayState<DmRoomEntity>>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('nothing fetched'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(index.toString()));
              },
            );
          }
        },
      ),
    );
  }
}
