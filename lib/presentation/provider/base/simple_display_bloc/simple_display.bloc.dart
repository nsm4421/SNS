import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:either_dart/either.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'simple_display.state.dart';

part 'simple_display.event.dart';

part 'simple_display.bloc.g.dart';

abstract class SimpleDisplayBloc<T>
    extends Bloc<SimpleDisplayEvent, SimpleDisplayState<T>>
    with AppLogger {
  SimpleDisplayBloc() : super(SimpleDisplayState<T>(data: [])) {
    on<RefreshDisplayEvent>(_onRefresh);
    on<FetchDisplayDataEvent>(_onFetchDataEvent);
  }

  Future<Either<Failure, Page<T>>> fetch({String? cursor, int limit = 20});

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
                    nextCursor: r.nextCursor,
                    data: r.items,
                  )
                  .copyWithNull(errorMessage: true),
            );
          },
        ),
      );
    } catch (error) {
      logger.e(error);
      emit(
        state.copyWith(
          status: DisplayStatus.error,
          errorMessage: 'error occurs',
        ),
      );
      await _resetStatus(emit);
    }
  }

  Future<void> _onFetchDataEvent(
    FetchDisplayDataEvent event,
    Emitter<SimpleDisplayState<T>> emit,
  ) async {
    try {
      if (state.nextCursor == null) {
        return;
      }
      emit(state.copyWith(status: DisplayStatus.fetching));
      await fetch(cursor: state.nextCursor, limit: event.limit).then(
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
                    nextCursor: r.nextCursor,
                    data: [...state.data, ...r.items],
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
          .copyWith(status: DisplayStatus.loaded)
          .copyWithNull(errorMessage: true),
    );
  }
}
