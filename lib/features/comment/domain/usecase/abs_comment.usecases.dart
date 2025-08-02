import 'package:either_dart/either.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/comment/domain/entity/abs/abs_comment.entity.dart';
import 'package:sns/features/comment/domain/repository/abs_comment.repository.dart';

part 'scenario/create_comment.usecase.dart';

part 'scenario/delete_comment.usecase.dart';

part 'scenario/find_comment_by_id.usecase.dart';

part 'scenario/fetch_comments.usecase.dart';

class AbsCommentUseCases<T extends AbsCommentEntity> {
  final AbsCommentRepository<T> _repository;

  AbsCommentUseCases(this._repository);

  CreateCommentUseCase get create => CreateCommentUseCase(_repository);

  DeleteCommentUseCase get delete => DeleteCommentUseCase(_repository);

  FindCommentByIdUseCase<T> get findById => FindCommentByIdUseCase<T>(_repository);

  FetchCommentsUseCase<T> get fetchComments =>
      FetchCommentsUseCase<T>(_repository);
}
