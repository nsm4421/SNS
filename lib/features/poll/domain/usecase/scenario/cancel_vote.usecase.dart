import 'package:either_dart/either.dart';
import 'package:sns/core/constant/api_error_type.constant.dart';
import 'package:sns/core/util/exception/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/util/exception/failure.dart';
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
