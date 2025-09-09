import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NetworkImageCarouselWidget extends StatefulWidget {
  const NetworkImageCarouselWidget(this._urls, {super.key});

  final List<String> _urls;

  @override
  State<NetworkImageCarouselWidget> createState() =>
      _NetworkImageCarouselWidgetState();
}

class _NetworkImageCarouselWidgetState
    extends State<NetworkImageCarouselWidget> {
  late PageController _pageController;

  @override
  initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _handleClickDot(int index) async {
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._urls.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width,
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget._urls.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: CachedNetworkImageProvider(widget._urls[index]),
                  ),
                ),
              );
            },
          ),
        ),

        if (widget._urls.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget._urls.length,
              onDotClicked: _handleClickDot,
              effect: WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                activeDotColor: Theme.of(context).colorScheme.secondary,
                dotColor: Theme.of(context).colorScheme.secondary.withAlpha(50),
              ),
            ),
          ),
      ],
    );
  }
}
