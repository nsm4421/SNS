part of '../poll.usecases.dart';

class CreateTopicUseCase with ApiErrorToFailureMapperMixIn {
  final PollRepository _repository;

  CreateTopicUseCase(this._repository);

  Future<Either<Failure, String>> call({
    required String title,
    required String description,
    required List<String> options,
  }) async {
    if (title.isEmpty) {
      return Left(Failure.validation('title is not given'));
    } else if (description.isEmpty) {
      return Left(Failure.validation('description is not given'));
    } else if (options.length < 2) {
      return Left(Failure.validation('at least give 2 option'));
    } else if (options.toSet().length != options.length) {
      return Left(Failure.validation('duplicated option'));
    }

    return await _repository
        .createTopic(title: title, description: description, options: options)
        .thenLeft((l) => Left(handleFailure(l)));
  }
}
