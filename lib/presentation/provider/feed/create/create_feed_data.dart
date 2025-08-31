part of 'create_feed.cubit.dart';

@CopyWith(copyWithNull: true)
class CreateFeedData {
  final String content;
  final List<XFile> images;

  CreateFeedData({this.content = '', required this.images});
}
