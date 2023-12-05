import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class MiracleSliverHeaderDelegate extends SliverPersistentHeaderDelegate {


  @override
  final TickerProvider vsync;

  MiracleSliverHeaderDelegate({
    this.titleWidget,
    required this.extentHeight,
    required this.backgroundColor,
    required this.vsync,
    this.titleMaxFontWeight = FontWeight.w700,
    this.titleMinFontWeight = FontWeight.w600,
    this.maxTitleFontSize = 24,
    this.minTitleFontSize = 16,
    this.headTitle,
    this.subTitle,
    this.styleSubTitle = const TextStyle(fontSize: 14, color: Colors.white),
    this.styleHeadTitle = const TextStyle(fontSize: 14, color: Colors.white),
    this.title,
    this.titleScale = 0.8,
    this.background,
    this.actions,
    this.decoration,
  }) : super();

  final double extentHeight;

  /// chỉ sử dụng [titleWidget] hoặc title;
  @Deprecated('Không sử dụng cái này nữa')
  final Widget? titleWidget;

  final String? title;

  /// paragraph text above title
  /// request by Mr.Lực, not actually tested yet
  final String? headTitle;

  /// paragraph text below title
  /// request by Mr.Lực, not actually tested yet
  final String? subTitle;

  final TextStyle styleHeadTitle;

  final TextStyle styleSubTitle;

  final FontWeight titleMaxFontWeight;

  final FontWeight titleMinFontWeight;

  final double minTitleFontSize;

  final double maxTitleFontSize;

  final double titleScale;

  final Color backgroundColor;

  final List<Widget>? actions;

  final Widget? background;

  final Decoration? decoration;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return DecoratedBox(
      decoration: decoration ??
          const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              stops: [0.11, 0.35],
              colors: [Color(0xff0061F3), Color(0xff0055C2)],
            ),
          ),
      child: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: 1 - shrinkOffset / extentHeight,
              child: background,
            ),
            // here provide actions
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions ?? [],
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: IconButton(
                 icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                   bool canPop =  Navigator.of(context).canPop();
                   if(canPop){
                     Navigator.of(context).pop();
                   }
                  },
                ),
              ),
            ),

            Align(
              alignment: Alignment(
                shrinkOffset / extentHeight - 1,
                1 - shrinkOffset / extentHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeadTitle(1 - shrinkOffset / extentHeight),
                    _buildTitle(1 - shrinkOffset / extentHeight),
                    _buildSubTitle(1 - shrinkOffset / extentHeight),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(double percent) {
    if (!(title?.isEmpty ?? true)) {
      final fontWeight =
      FontWeight.lerp(titleMinFontWeight, titleMaxFontWeight, percent);

      final fontSize =
          (maxTitleFontSize - minTitleFontSize) * percent + minTitleFontSize;

      return Text(
        title!,
        style: TextStyle(
          fontWeight: fontWeight,
          color: Colors.white,
          fontSize: fontSize,
        ),
      );
    }

    return Transform.scale(
        scale: (1 - titleScale) * percent + titleScale,
        child: titleWidget ?? const SizedBox.shrink());
  }

  @override
  double get maxExtent => extentHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant MiracleSliverHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration =>
      FloatingHeaderSnapConfiguration(
        curve: Curves.linear,
        duration: const Duration(milliseconds: 100),
      );

  _buildHeadTitle(double percent) {
    if (headTitle?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Opacity(
      opacity: percent,
      child: Text(
        headTitle!,
        style: styleHeadTitle.copyWith(
            fontSize: styleHeadTitle.fontSize! * percent),
      ),
    );
  }

  _buildSubTitle(double percent) {
    if (subTitle?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }
    return Opacity(
      opacity: percent,
      child: Text(subTitle!,
          style: styleSubTitle.copyWith(
              fontSize: styleSubTitle.fontSize! * percent)),
    );
  }
}
