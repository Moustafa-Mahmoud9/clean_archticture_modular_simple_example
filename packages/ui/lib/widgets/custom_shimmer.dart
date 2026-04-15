import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmer extends StatelessWidget {
  const CommonShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    required this.enabled,
    this.direction = ShimmerDirection.ltr,
    this.period,
  });

  final bool enabled;
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final ShimmerDirection direction;
  final Duration? period;


  factory CommonShimmer.box({
    double width = double.infinity,
    double height = 16,
    double borderRadius = 4,
    bool enabled = true,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return CommonShimmer(
      enabled: enabled,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final defaultBaseColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final defaultHighlightColor = isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    if (!enabled) return child;

    return Shimmer.fromColors(
      baseColor: baseColor ?? defaultBaseColor,
      highlightColor: highlightColor ?? defaultHighlightColor,
      direction: direction,
      period: period ?? const Duration(milliseconds: 2200),
      child: child,
    );
  }
}