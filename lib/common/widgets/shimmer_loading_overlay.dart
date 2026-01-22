import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:next_kick/utilities/constants/enums/shimmer_enum.dart';

class ShimmerLoadingOverlay extends StatefulWidget {
  final ShimmerEnum pageType;
  final bool isDarkMode;

  const ShimmerLoadingOverlay({
    super.key,
    required this.pageType,
    this.isDarkMode = false,
  });

  @override
  State<ShimmerLoadingOverlay> createState() => _ShimmerLoadingOverlayState();
}

class _ShimmerLoadingOverlayState extends State<ShimmerLoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(child: _buildShimmerLayout()),
      ),
    );
  }

  Widget _buildShimmerLayout() {
    switch (widget.pageType) {
      case ShimmerEnum.drills:
        return _buildDrillsShimmer();
      case ShimmerEnum.notification:
        return _buildNotificationsShimmer();
    }
  }

  Widget _buildDrillsShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (_, _) => SizedBox(height: 12),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFD6E6F2), // base shimmer color
                  Color(0xFFE9F3FA), // lighter shimmer color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationsShimmer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          separatorBuilder: (_, _) => SizedBox(height: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 8,
          itemBuilder: (context, index) {
            return _buildShimmerBox(double.infinity, 100, index * 300);
          },
        ),
      ],
    );
  }

  Widget _buildShimmerBox(
    double width,
    double height,
    int delay, {
    double radius = 4,
  }) {
    return FadeShimmer(
      width: width,
      height: height,
      radius: radius,
      millisecondsDelay: delay,
      fadeTheme: widget.isDarkMode ? FadeTheme.dark : FadeTheme.light,
    );
  }

  // Widget _buildShimmerCircle(double size, int delay) {
  //   return FadeShimmer.round(
  //     size: size,
  //     fadeTheme: widget.isDarkMode ? FadeTheme.dark : FadeTheme.light,
  //     millisecondsDelay: delay,
  //   );
  // }
}
