import 'package:mocktail/mocktail.dart';
import 'package:supabase_datasource/src/db/chat/dm/room/dm_room.datasource.dart';
import 'package:supabase_datasource/src/models/chat/dm_room.model.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';
import 'package:test/test.dart';

class MockDmRoomsTable extends Mock implements DmRoomsTable {}

class MockVMyDmRoomsTable extends Mock implements VMyDmRoomsTable {}

void main() {
  late MockDmRoomsTable dmRoomsTable;
  late MockVMyDmRoomsTable vMyDmRoomsTable;
  late SupabaseDmRoomDataSourceImpl dataSource;

  setUp(() {
    dmRoomsTable = MockDmRoomsTable();
    vMyDmRoomsTable = MockVMyDmRoomsTable();
    dataSource = SupabaseDmRoomDataSourceImpl(
      dmRoomsTable: dmRoomsTable,
      vMyDmRoomsTable: vMyDmRoomsTable,
    );
  });

  group("SupabaseDmRoomDataSourceImpl", () {
    group("fetch", () {
      test('정상동작', () async {
        // given
        const cursor = '2025-10-06T00:00:00Z';
        const limit = 50;
        final rows = <VMyDmRoomsRow>[
          VMyDmRoomsRow.fromJson(const {
            'id': 'r1',
            'counterpart_id': 'u2',
            'sort_ts': '2025-10-05T10:00:00Z',
            'name': 'room-1',
          }),
          VMyDmRoomsRow.fromJson(const {
            'id': 'r2',
            'counterpart_id': 'u3',
            'sort_ts': '2025-10-05T09:00:00Z',
            'name': 'room-2',
          }),
        ];

        when(
          () => vMyDmRoomsTable.queryRows(
            queryFn: any(named: 'queryFn'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => rows);

        final result = await dataSource.fetch(cursor: cursor, limit: limit);

        expect(result, rows);
        verify(
          () => vMyDmRoomsTable.queryRows(
            queryFn: any(named: 'queryFn'),
            limit: limit,
          ),
        ).called(1);
        verifyNoMoreInteractions(vMyDmRoomsTable);
        verifyZeroInteractions(dmRoomsTable);
      });
    });

    group("create", () {
      const currentUserId = 'a_user';
      const otherUserId = 'b_user';
      final row = DmRoomsRow.fromJson(const {
        'id': 'room-x',
        'user1_id': currentUserId,
        'user2_id': otherUserId,
      });
      final viewRow = VMyDmRoomsRow.fromJson(const {
        'room_id': 'room-x',
        'counterpart_id': otherUserId,
        'sort_ts': '2025-10-05T13:00:00Z',
        'created_at': '2025-10-05T13:00:00Z',
        'updated_at': '2025-10-05T13:00:00Z',
      });
      final model = DmRoomModel.fromRow(
        row: viewRow,
        currentUserId: currentUserId,
      );

      test('정상동작', () async {
        when(
          () => dmRoomsTable.insert(any()),
        ).thenAnswer((_) async => row);

        final result = await dataSource.create(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        );

        expect(result.id, model.roomId);
        verify(() => dmRoomsTable.insert(any())).called(1);
        verifyNoMoreInteractions(dmRoomsTable);
        verifyZeroInteractions(vMyDmRoomsTable);
      });
    });
  });
}
