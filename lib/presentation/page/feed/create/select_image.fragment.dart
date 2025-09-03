part of 'create_feed.page.dart';

class SelectImageFragment extends StatefulWidget {
  const SelectImageFragment({super.key});

  @override
  State<SelectImageFragment> createState() => _SelectImageFragmentState();
}

class _SelectImageFragmentState extends State<SelectImageFragment> {
  late final ImagePicker _imagePicker;
  static const double _imageAvatarSize = 120;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  _handleSelectImage() async {
    final maxImageCount = context.read<CreateFeedCubit>().maxImageCount;
    final maxImageCountCanSelect = context
        .read<CreateFeedCubit>()
        .maxImageCountCanSelect;
    final selected = await _imagePicker.pickMultiImage(limit: maxImageCount);
    if (selected.isEmpty) {
      return;
    } else if (selected.length > maxImageCountCanSelect) {
      context
        ..read<CreateFeedCubit>().selectImages(
          selected.sublist(0, maxImageCountCanSelect),
        )
        ..showErrorSnackBar('최대 $maxImageCount개까지만 선택가능합니다');
    } else {
      context.read<CreateFeedCubit>().selectImages(selected);
    }
  }

  _handleUnSelect(int index) => () {
    context.read<CreateFeedCubit>().unSelectImage(index);
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFeedCubit, SimpleDataState<CreatePostData>>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Images', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  onPressed: state.status == Status.initial
                      ? _handleSelectImage
                      : null,
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  tooltip: 'Select Image',
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (state.data.images.isEmpty)
              Text(
                '선택된 이미지가 없습니다',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.blueGrey),
              ),

            // preview
            if (state.data.images.isNotEmpty)
              SizedBox(
                height: _imageAvatarSize,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.data.images.indexed.map((e) {
                      return Container(
                        width: _imageAvatarSize,
                        height: _imageAvatarSize,
                        margin: const EdgeInsets.only(right: 24),
                        child: Stack(
                          children: [
                            Container(
                              width: _imageAvatarSize,
                              height: _imageAvatarSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(e.$2.path)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -_imageAvatarSize / 10,
                              right: -_imageAvatarSize / 10,
                              child: IconButton(
                                onPressed: _handleUnSelect(e.$1),
                                icon: const Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: Colors.blueGrey,
                                ),
                                tooltip: 'UnSelect',
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
