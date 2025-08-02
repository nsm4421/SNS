import 'package:either_dart/either.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/domain/entity/abs/abs_comment.entity.dart';
import 'package:sns/features/comment/domain/usecase/abs_comment.usecases.dart';

abstract class AbsDisplayCommentsBloc<T extends AbsCommentEntity>
    extends SimpleDisplayBloc<T> {
  AbsDisplayCommentsBloc({
    required AbsCommentUseCases<T> useCases,
    required String refId,
  }) : _refId = refId,
       super(SimpleDisplayState<T>(data: [])) {
    this._useCase = useCases.fetchComments;
  }

  late final FetchCommentsUseCase<T> _useCase;
  final String _refId;

  @override
  Future<Either<Failure, List<T>>> fetch({
    DateTime? cursor,
    int limit = 20,
  }) async {
    return await _useCase.call(refId: _refId, cursor: cursor, limit: limit);
  }
}
