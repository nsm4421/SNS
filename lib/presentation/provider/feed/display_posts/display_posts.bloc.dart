import 'package:fpdart/src/either.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/exception/failure.dart';
import 'package:karma/core/vo/pageable.vo.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/usecase/feed/feed.usecaes.dart';
import 'package:karma/presentation/provider/display/display.bloc.dart';

@injectable
class DisplayPostsBloc extends DisplayBloc<FeedPostEntityWithAuthor> {
  final FeedUseCases _feedUseCases;
  static const int _pageSize = 10;

  DisplayPostsBloc(this._feedUseCases)
    : super(pageSize: _pageSize, prependOnUpsert: true);

  @override
  Future<Either<Failure, Pageable<FeedPostEntityWithAuthor>>> fetch({
    required String cursor,
    int limit = _pageSize,
  }) async {
    return await _feedUseCases
        .fetchPosts(cursor: cursor, limit: limit)
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
  String idOf(FeedPostEntityWithAuthor item) {
    return item.postId;
  }
}
