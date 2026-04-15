import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension TextStyleExtension on BuildContext {
  double get fontMultipe => (height * 0.001);

  double get width => MediaQuery.sizeOf(this).width;

  double get height => MediaQuery.sizeOf(this).height;

  TextStyle textStyleSmall({bool isNumer = false}) {
    return TextStyle(
        fontSize: (fontMultipe) * 14,
        fontWeight: FontWeight.w400,
        wordSpacing: 1.2,
        height: 1,
        color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);
  }

  TextStyle textStyleThin({bool isNumer = false}) => TextStyle(
      fontSize: (fontMultipe) * 12,
      fontWeight: FontWeight.w400,
      wordSpacing: 1.2,
      height: 1,
      color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);

  TextStyle textStyleRegular({bool isNumer = false}) {
    return TextStyle(
        fontSize: (fontMultipe) * 16,
        fontWeight: FontWeight.w400,
        wordSpacing: 1.2,
        height: 1.3,
        color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);
  }

  TextStyle textRedStyleRegular({bool isNumer = false}) {
    return TextStyle(
        fontSize: (fontMultipe) * 16,
        fontWeight: FontWeight.w400,
        wordSpacing: 1.2,
        height: 1.2,
        color: Colors.red);
  }

  TextStyle textStyleMainSectionDrawer({bool isNumer = false}) {
    return TextStyle(
        fontSize: (fontMultipe) * 18,
        fontWeight: FontWeight.w600,
        wordSpacing: 1.5,
        height: 1.5,
        color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);
  }

  TextStyle textStyleSemiBold({bool isNumer = false}) => TextStyle(
      fontWeight: FontWeight.w700,
      height: 1,
      fontSize: (fontMultipe) * 20,
      color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);

  TextStyle textStyleBold({bool isNumer = false}) => TextStyle(
      fontSize: (fontMultipe) * 24,
      fontWeight: FontWeight.w800,
      color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);

  TextStyle textStyleExtraBold({bool isNumer = false}) => TextStyle(
      fontSize: (fontMultipe) * 26,
      fontWeight: FontWeight.w900,
      color: Theme.of(this).textTheme.bodyMedium?.color ?? Colors.white);

  TextStyle textStyleError({bool isNumer = false}) => TextStyle(
      fontSize: (fontMultipe) * 14,
      fontWeight: FontWeight.w600,
      color: AppColors.redColor);
}
