import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/usecase/usecase.export.dart';
import 'package:karma/presentation/provider/display/display.bloc.dart';

@lazySingleton
class DisplayDmRoomsBloc extends DisplayBloc<DmRoomEntity> {
  DisplayDmRoomsBloc(DmUseCases dmUseCases) {
    _fetchDmRoomsUseCase = dmUseCases.fetchRooms;
  }

  late final FetchDmRoomsUseCase _fetchDmRoomsUseCase;

  @override
  Future<Either<Failure, Pageable<DmRoomEntity>>> fetch({
    required String cursor, // sort_ts
    int limit = 30,
  }) async {
    return await _fetchDmRoomsUseCase
        .call(cursor: cursor, limit: limit)
        .then(
          (res) => res.map((r) {
            final cursor = (r.items.isEmpty || r.items.length < limit)
                ? null
                : r.items
                      .map((e) => e.sortTs)
                      .reduce((v, e) => v.isAfter(e) ? e : v)
                      .toIso8601String();
            return r.copyWithNextCursor(cursor);
          }),
        );
  }

  @override
  String idOf(DmRoomEntity item) {
    return item.roomId;
  }
}
