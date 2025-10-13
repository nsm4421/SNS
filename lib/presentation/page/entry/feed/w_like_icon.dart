part of 'p_feed_tab.dart';

class LikeIconWidget extends StatefulWidget {
  const LikeIconWidget(this._feed, {super.key});

  final FeedPostEntityWithAuthor _feed;

  @override
  State<LikeIconWidget> createState() => _LikeIconWidgetState();
}

class _LikeIconWidgetState extends State<LikeIconWidget> {
  late bool _likeByMe;
  late int _likeCount;
  late bool _tappable;
  static const int _duration = 300;

  @override
  void initState() {
    super.initState();
    _likeByMe = widget._feed.likedByMe;
    _likeCount = widget._feed.likeCount;
    _tappable = true;
  }

  Future<void> _handleToggleLike() async {
    setState(() {
      _tappable = false;
    });
    await GetIt.instance<FeedUseCases>().toggleLike
        .call(widget._feed.postId)
        .then(
          (res) => res.match(
            (l) {
              debugPrint('toggle like fails >> ${l.repr}');
            },
            (r) {
              debugPrint('toggle like success');
              _likeByMe = r.$1;
              _likeCount = r.$2;
            },
          ),
        );
    await Future.delayed(const Duration(milliseconds: _duration), () {
      setState(() {
        _tappable = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _tappable ? _handleToggleLike : null,
          icon: Icon(
            _likeByMe ? Icons.favorite : Icons.favorite_border,
            color: _tappable
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
        ),
        Text(_likeCount.toString()),
      ],
    );
  }
}
