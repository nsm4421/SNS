part of 'display_feed.page.dart';

class FeedImageCarouselWidget extends StatefulWidget {
  const FeedImageCarouselWidget(this._feed, {super.key});

  final FeedEntity _feed;

  @override
  State<FeedImageCarouselWidget> createState() =>
      _FeedImageCarouselWidgetState();
}

class _FeedImageCarouselWidgetState extends State<FeedImageCarouselWidget> {
  late int _currentIndex;

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: PageView.builder(
        itemCount: widget._feed.images.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: CachedNetworkImageProvider(widget._feed.images[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
