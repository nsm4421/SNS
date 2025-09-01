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

  late final List<num> _aspects;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _aspects = List.generate(widget._feed.images.length, (index) {
      final width = widget._feed.widths[index];
      final height = widget._feed.heights[index];
      final aspect = width / height;
      return aspect.clamp(0.5, 2);
    });
  }

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: MediaQuery.of(context).size.width / _aspects[_currentIndex],
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
