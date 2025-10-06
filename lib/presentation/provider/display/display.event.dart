part of 'display.bloc.dart';

@freezed
class DisplayEvent<T> with _$DisplayEvent<T> {
  const factory DisplayEvent.started() = _Started<T>;

  const factory DisplayEvent.refreshed() = _Refreshed<T>;

  const factory DisplayEvent.nextPageRequested() = _NextPageRequested<T>;

  const factory DisplayEvent.upserted(T item) = _Upserted<T>;

  const factory DisplayEvent.removed(String id) = _Removed<T>;
}
