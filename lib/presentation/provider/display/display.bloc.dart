import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:karma/core/core.export.dart';

part 'display.state.dart';

part 'display.event.dart';

part 'display.bloc.freezed.dart';

abstract class DisplayBloc<T> extends Bloc<DisplayEvent<T>, DisplayState<T>> {
  final int pageSize;
  final bool prependOnUpsert;

  DisplayBloc({this.pageSize = 30, this.prependOnUpsert = true})
    : super(DisplayState<T>()) {
    on<_Started<T>>(_onStarted, transformer: restartable());
    on<_Refreshed<T>>(_onRefreshed, transformer: restartable());
    on<_NextPageRequested<T>>(_onNextPageRequested, transformer: droppable());
    on<_Upserted<T>>(_onUpserted);
    on<_Removed<T>>(_onRemoved);
  }

  /// 페이지 로더 (반드시 구현)
  @protected
  Future<Either<Failure, Pageable<T>>> fetch({
    required String cursor,
    int limit = 30,
  });

  /// 아이템의 고유 id 선택자 (반드시 구현)
  @protected
  String idOf(T item);

  /// 초기/리프레시 커서 (필요시 오버라이드)
  @protected
  String initialCursor() => DateTime.now().toUtc().toIso8601String();

  /// upsert 시 정렬 (필요시 오버라이드)
  @protected
  List<T> reorderAfterUpsert(List<T> current, T upserted) {
    final filtered = current
        .where((e) => idOf(e) != idOf(upserted))
        .toList(growable: true);
    if (prependOnUpsert) {
      filtered.insert(0, upserted);
      return filtered;
    }
    filtered.add(upserted);
    return filtered;
  }

  Future<void> _onStarted(
    _Started<T> event,
    Emitter<DisplayState<T>> emit,
  ) async {
    emit(state.copyWith(status: DisplayStatus.loading, failure: null));
    await fetch(cursor: initialCursor(), limit: pageSize).then(
      (res) => res.match(
        (failure) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            failure: failure,
            items: const [],
            nextCursor: null,
          ),
        ),
        (page) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            failure: null,
            items: page.items,
            nextCursor: page.nextCursor,
          ),
        ),
      ),
    );
  }

  Future<void> _onRefreshed(
    _Refreshed<T> event,
    Emitter<DisplayState<T>> emit,
  ) async {
    emit(state.copyWith(status: DisplayStatus.refreshing, failure: null));
    await fetch(cursor: initialCursor(), limit: pageSize).then(
      (res) => res.match(
        (failure) => emit(
          state.copyWith(status: DisplayStatus.initial, failure: failure),
        ),
        (page) => emit(
          state.copyWith(
            status: DisplayStatus.initial,
            failure: null,
            items: page.items,
            nextCursor: page.nextCursor,
          ),
        ),
      ),
    );
  }

  Future<void> _onNextPageRequested(
    _NextPageRequested<T> event,
    Emitter<DisplayState<T>> emit,
  ) async {
    if (state.isEnd ||
        state.status == DisplayStatus.loading ||
        state.status == DisplayStatus.refreshing ||
        state.status == DisplayStatus.paginated) {
      return;
    }

    emit(state.copyWith(status: DisplayStatus.paginated, failure: null));

    await fetch(
      cursor: state.nextCursor ?? initialCursor(),
      limit: pageSize,
    ).then(
      (res) => res.match(
        (failure) => emit(
          state.copyWith(status: DisplayStatus.initial, failure: failure),
        ),
        (page) {
          final merged = _mergeAppendUniqueById(state.items, page.items);
          emit(
            state.copyWith(
              status: DisplayStatus.initial,
              failure: null,
              items: merged,
              nextCursor: page.nextCursor,
            ),
          );
        },
      ),
    );
  }

  void _onUpserted(_Upserted<T> event, Emitter<DisplayState<T>> emit) {
    emit(state.copyWith(items: reorderAfterUpsert(state.items, event.item)));
  }

  void _onRemoved(_Removed<T> event, Emitter<DisplayState<T>> emit) {
    emit(
      state.copyWith(
        items: state.items
            .where((e) => idOf(e) != event.id)
            .toList(growable: false),
      ),
    );
  }

  List<T> _mergeAppendUniqueById(List<T> current, List<T> incoming) {
    if (incoming.isEmpty) return current;
    final existingIds = {for (final e in current) idOf(e)};
    final toAppend = incoming.where((e) => !existingIds.contains(idOf(e)));
    return List<T>.from(current)..addAll(toAppend);
  }
}
