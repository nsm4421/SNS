import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/poll/domain/repository/poll.repository.dart';

class CancelVoteUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CancelVoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String optionId) async {
    final deleteVoteRes = await _repository.deleteVoteByOption(optionId);
    if (deleteVoteRes.isLeft &&
        deleteVoteRes.left.type != ApiErrorType.notFound) {
      return Left(handleFailure(deleteVoteRes.left));
    }

    return const Right(null);
  }
}
