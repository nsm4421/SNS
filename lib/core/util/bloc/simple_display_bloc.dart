import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/util/exception/failure.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';

part 'simple_display_state.dart';

part 'simple_display_event.dart';

part 'simple_display_bloc.g.dart';

abstract class SimpleDisplayBloc<T>
    extends Bloc<SimpleDisplayEvent, SimpleDisplayState<T>>
    with AppLogger {
  SimpleDisplayBloc(super.initialState) {
    on<RefreshDisplayEvent>(_onRefresh);
    on<FetchDisplayDataEvent>(_onFetchDataEvent);
  }

  Future<Either<Failure, List<T>>> fetch({DateTime? cursor, int limit = 20});

  DateTime get cursor;

  Future<void> _onRefresh(
    RefreshDisplayEvent event,
    Emitter<SimpleDisplayState<T>> emit,
  ) async {
    try {
      emit(state.copyWith(status: DisplayStatus.fetching));
      await fetch().then(
        (res) => res.fold(
          (l) async {
            emit(
              state.copyWith(
                status: DisplayStatus.error,
                errorMessage: l.message,
              ),
            );
            await _resetStatus(emit);
          },
          (r) {
            emit(
              state
                  .copyWith(
                    status: DisplayStatus.loaded,
                    isEnd: r.length < event.limit,
                    data: r,
                  )
                  .copyWithNull(errorMessage: true),
            );
          },
        ),
      );
    } catch (error) {
      logger.e(error);
      emit(state.copyWith(status: DisplayStatus.error));
      await _resetStatus(emit);
    }
  }

  Future<void> _onFetchDataEvent(
    FetchDisplayDataEvent event,
    Emitter<SimpleDisplayState<T>> emit,
  ) async {
    try {
      if (state.isEnd) {
        return;
      }
      emit(state.copyWith(status: DisplayStatus.fetching));
      await fetch(cursor: cursor, limit: event.limit).then(
        (res) => res.fold(
          (l) async {
            emit(
              state.copyWith(
                status: DisplayStatus.error,
                errorMessage: l.message,
              ),
            );
            await _resetStatus(emit);
          },
          (r) {
            emit(
              state
                  .copyWith(
                    status: DisplayStatus.loaded,
                    isEnd: r.length < event.limit,
                    data: [...state.data, ...r],
                  )
                  .copyWithNull(errorMessage: true),
            );
          },
        ),
      );
    } catch (error) {
      logger.e(error);
      emit(state.copyWith(status: DisplayStatus.error));
      await _resetStatus(emit);
    }
  }

  _resetStatus(
    Emitter<SimpleDisplayState<T>> emit, {
    Duration? duration,
  }) async {
    await Future.delayed(duration ?? const Duration(seconds: 1));
    emit(
      state
          .copyWith(status: DisplayStatus.initial)
          .copyWithNull(errorMessage: true),
    );
  }
}
