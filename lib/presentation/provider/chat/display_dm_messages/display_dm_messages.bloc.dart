import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/usecase/usecase.export.dart';
import 'package:karma/presentation/provider/display/display.bloc.dart';

@injectable
class DisplayDmMessagesBloc extends DisplayBloc<DmMessageEntity> {
  DisplayDmMessagesBloc(
    @factoryParam this._roomId, {
    required DmUseCases dmUseCases,
  }) {
    _fetchDmMessagesUseCase = dmUseCases.fetchMessages;
  }

  final String _roomId;
  late final FetchDmMessagesUseCase _fetchDmMessagesUseCase;

  String get roomId => _roomId;

  @override
  Future<Either<Failure, Pageable<DmMessageEntity>>> fetch({
    required String cursor, // created_at
    int limit = 30,
  }) async {
    return await _fetchDmMessagesUseCase
        .call(roomId: _roomId, cursor: cursor, limit: limit)
        .then(
          (res) => res.map((r) {
            final cursor = (r.items.isEmpty || r.items.length < limit)
                ? null
                : r.items
                      .map((e) => e.createdAt)
                      .reduce((v, e) => v.isAfter(e) ? e : v)
                      .toUtc()
                      .toIso8601String();
            return r.copyWithNextCursor(cursor);
          }),
        );
  }

  @override
  String idOf(DmMessageEntity item) {
    return item.roomId;
  }
}
