import 'package:flutter/material.dart';

/// A low-level text button primitive for a core / design-system package.
///
/// Renders as plain tappable text with no background or border.
/// Supports an optional underline, optional leading/trailing icon,
/// disabled state (onTap == null), and a loading state.
///
/// ### Call-site examples
///
/// Simple text link:
/// ```dart
/// CommonTextButton(
///   onTap: onForgotPassword,
///   label: const Text('هل نسيت كلمه المرور؟'),
/// )
/// ```
///
/// Underlined (matches image 1 style):
/// ```dart
/// CommonTextButton(
///   onTap: onForgotPassword,
///   underlined: true,
///   label: const Text('هل نسيت كلمه المرور؟'),
/// )
/// ```
///
/// With leading icon:
/// ```dart
/// CommonTextButton(
///   onTap: onTap,
///   leadingIcon: Icons.add,
///   label: const Text('إضافة جديد'),
/// )
/// ```
///
/// Disabled (no callback):
/// ```dart
/// CommonTextButton(onTap: null, label: const Text('غير متاح'))
/// ```
class CommonTextButton extends StatelessWidget {
  const CommonTextButton({
    super.key,
    required this.onTap,
    required this.label,
    this.leadingIcon,
    this.leadingIconSize = 18.0,
    this.trailingIcon,
    this.trailingIconSize = 18.0,
    this.color,
    this.underlined = false,
    this.gapBetweenSlots = 6.0,
    this.isLoading = false,
    this.padding = EdgeInsets.zero,
  });

  /// Null → disabled. Tap area is preserved but onTap is not fired.
  final VoidCallback? onTap;

  /// The text content. Pass a [Text] widget so the caller controls typography.
  final Widget label;

  /// Optional icon on the left of the label.
  final IconData? leadingIcon;
  final double leadingIconSize;

  /// Optional icon on the right of the label.
  final IconData? trailingIcon;
  final double trailingIconSize;

  /// Text and icon colour. Defaults to the theme's primary colour when null.
  final Color? color;

  /// When true, draws an underline below the label text.
  /// Implemented via [DefaultTextStyle] decoration so it respects RTL.
  final bool underlined;

  /// Gap between icon and label. Defaults to 6.
  final double gapBetweenSlots;

  /// Shows a small [CircularProgressIndicator] and blocks taps.
  final bool isLoading;

  /// Padding around the hit area. Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry padding;

  bool get _isDisabled => onTap == null;
  bool get _isInteractive => !_isDisabled && !isLoading;

  Color _resolveColor(BuildContext context) {
    if (_isDisabled) return Colors.grey.shade400;
    return color ?? Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final fg = _resolveColor(context);

    Widget content;

    if (isLoading) {
      content = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    } else {
      final hasLeading = leadingIcon != null;
      final hasTrailing = trailingIcon != null;

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasLeading) ...[
            Icon(leadingIcon, size: leadingIconSize, color: fg),
            SizedBox(width: gapBetweenSlots),
          ],
          DefaultTextStyle.merge(
            style: TextStyle(
              color: fg,
              decoration: underlined ? TextDecoration.underline : TextDecoration.none,
              decorationColor: fg,
            ),
            child: label,
          ),
          if (hasTrailing) ...[
            SizedBox(width: gapBetweenSlots),
            Icon(trailingIcon, size: trailingIconSize, color: fg),
          ],
        ],
      );
    }

    return GestureDetector(
      onTap: _isInteractive ? onTap : null,
      child: Padding(
        padding: padding,
        child: content,
      ),
    );
  }
}