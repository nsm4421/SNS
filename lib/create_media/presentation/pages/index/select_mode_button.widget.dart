part of 'create_media.page.dart';

class SelectModeButtonWidget extends StatelessWidget {
  const SelectModeButtonWidget({super.key});

  static const double _floatingButtonWidth = 160;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateMediaCubit, CreateMediaState>(
        builder: (context, state) {
      return AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          bottom: CustomSpacing.lg,
          left: state.mode.index == 0
              ? MediaQuery.of(context).size.width / 2 - _floatingButtonWidth / 3
              : MediaQuery.of(context).size.width / 2 -
                  _floatingButtonWidth / 1.5,
          child: Container(
              width: _floatingButtonWidth,
              padding: EdgeInsets.symmetric(
                  horizontal: CustomSpacing.sm, vertical: CustomSpacing.tiny),
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(CustomSpacing.md)),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SingleSelectModeButtonWidget(CreateMediaMode.feed),
                    CustomWidth.md,
                    const SingleSelectModeButtonWidget(CreateMediaMode.reels),
                  ])));
    });
  }
}

class SingleSelectModeButtonWidget extends StatelessWidget {
  const SingleSelectModeButtonWidget(this._mode, {super.key});

  final CreateMediaMode _mode;

  @override
  Widget build(BuildContext context) {
    final currentMode = context.read<CreateMediaCubit>().state.mode;
    return GestureDetector(
        onTap: () {
          context.read<CreateMediaCubit>().switchMode(_mode);
        },
        child: Text(_mode.label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(_mode.index == 0 ? 1 : 0.5),
                fontWeight: _mode.index == currentMode.index
                    ? FontWeight.bold
                    : FontWeight.normal)));
  }
}
