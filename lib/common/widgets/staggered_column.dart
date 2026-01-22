import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum StaggerType {scale, flip, slide}
enum SlideAxis {vertical, horizontal}

class StaggeredColumn extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final StaggerType staggerType;
  final SlideAxis slideAxis;
  const StaggeredColumn({super.key, this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max, this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection, this.verticalDirection = VerticalDirection.down,
    this.textBaseline, this.children = const <Widget>[], this.staggerType = StaggerType.slide,
    this.slideAxis = SlideAxis.horizontal});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: AnimationConfiguration.toStaggeredList(
          childAnimationBuilder: (widget) => staggerType == StaggerType.flip? FlipAnimation(
            child: FadeInAnimation(
              child: widget,
            ),
          ) : staggerType == StaggerType.scale? ScaleAnimation(
            child: FadeInAnimation(
              child: widget,
            ),
          ) : SlideAnimation(
            verticalOffset: slideAxis == SlideAxis.vertical ? 50.0 : null,
            horizontalOffset: slideAxis == SlideAxis.horizontal? 80.0 : null,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}
