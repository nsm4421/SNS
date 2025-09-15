import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/failure/failure.dart';
import 'package:sns/domain/repository/dm.repository.dart';

class GetDmConversationUseCase {
  final DmRepository _repository;
  final Logger? logger;

  const GetDmConversationUseCase(this._repository, {this.logger});

  Future<Either<Failure, String>> call(String otherUid) async {
    return await _repository
        .getConversationByOtherUid(otherUid)
        .then(
          (res) => res.fold(
            (l) => Left(Failure.conflict('DM을 보낼 수 없습니다')),
            (r) => Right(r),
          ),
        );
  }
}
