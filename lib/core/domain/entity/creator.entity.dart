import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:sns/core/data/model/creator.model.dart';

part 'creator.entity.g.dart';

@CopyWith()
class CreatorEntity {
  final String id;
  final String username;

  CreatorEntity({required this.id, required this.username});

  factory CreatorEntity.from(CreatorModel model){
    return CreatorEntity(id : model.id, username : model.username);
  }
}
