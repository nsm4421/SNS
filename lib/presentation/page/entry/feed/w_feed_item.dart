part of 'p_feed_tab.dart';

class _FeedItemWidget extends StatelessWidget {
  const _FeedItemWidget(this._feed, {super.key});

  final FeedPostEntityWithAuthor _feed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(child: Text("A")),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _feed.author.username ?? 'Unknown',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _feed.createdAt.toLocal().diffText,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.blueGrey),
                    ),
                  ],
                ),

                if (_feed.content.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      _feed.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                if (_feed.medias.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.width,
                    ),
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _feed.medias.length,
                      itemBuilder: (context, index) {
                        final media = _feed.medias[index];
                        return media.url == null
                            ? const SizedBox.shrink()
                            : Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          media.url!,
                                          cacheKey: 'feed:${media.storagePath}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  if (_feed.medias.length >= 2)
                                    Positioned(
                                      right: 12,
                                      bottom: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0x66000000), // 반투명 검정
                                              Color(0xCC000000), // 더 진한 검정
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          "${index + 1}/${_feed.medias.length}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                      },
                    ),
                  ),

                Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [LikeIconWidget(_feed)]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
