part of 'p_create_post.dart';

class _MediaFragment extends StatefulWidget {
  const _MediaFragment({super.key});

  @override
  State<_MediaFragment> createState() => _MediaFragmentState();
}

class _MediaFragmentState extends State<_MediaFragment>
    with PermissionHelperMixIn {
  static const int _maxAssetCount = 5;
  static const double _imageSize = 100;

  Future<void> _pickMedia() async {
    final permitted = await handleGalleryPermission();
    if (!permitted) {
      context.showWarningSnackBar('plz permit gallery access');
      debugPrint('권한 거절됨');
      return;
    }
    await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType.image,
        maxAssets: _maxAssetCount,
        selectedAssets: context.read<CreatePostCubit>().state.assets,
        gridCount: 4,
        textDelegate: const EnglishAssetPickerTextDelegate(),
      ),
    ).then((selected) {
      if (selected == null || selected.isEmpty) return;
      context.read<CreatePostCubit>().selectAssets(selected);
    });
  }

  _unSelectMedia(int index) => () {
    context.read<CreatePostCubit>().removeMediaAt(index);
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Media', style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                if (state.assets.length < _maxAssetCount)
                  IconButton(
                    onPressed: _pickMedia,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            state.assets.isEmpty
                ? Text(
                    "Nothing Fetched",
                    style: Theme.of(context).textTheme.labelMedium,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.assets.indexed
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 36),
                              child: Stack(
                                children: [
                                  Container(
                                    width: _imageSize,
                                    height: _imageSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetEntityImageProvider(e.$2),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -_imageSize / 6,
                                    right: -_imageSize / 6,
                                    child: IconButton(
                                      onPressed: _unSelectMedia(e.$1),
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
