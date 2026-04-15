import 'package:flutter/material.dart';

/// Controls what the button renders and how its container is shaped.
enum ButtonShape {
  /// Rounded rectangle showing [leading] + [label] + [trailing] in a row.
  rounded,

  /// Perfect circle showing only the [leading] slot centred.
  /// [label] and [trailing] are ignored.
  circle,

  /// Rounded rectangle showing **only** the [leading] slot centred.
  /// Use this when the button has a small or fixed width and you want a
  /// single icon to appear cleanly without any overflow logic.
  /// [label] and [trailing] are ignored.
  iconOnly,
}

/// A low-level, fully composable button primitive for a core / design-system
/// package.
///
/// ### Shape variants
///
/// | Shape       | Shows                        | Typical use                  |
/// |-------------|------------------------------|------------------------------|
/// | rounded     | leading + label + trailing   | Standard CTA button          |
/// | circle      | leading only, circular frame | FAB / avatar action          |
/// | iconOnly    | leading only, rounded frame  | Small-width icon button      |
///
/// ### Content slots
/// Each side (leading / trailing) resolves in priority order:
///   convenience icon param → convenience image param → raw widget slot
///
/// ### Overflow
/// [ButtonShape.iconOnly] is the correct answer for a small fixed [width].
/// The button shows a single centred icon with no clipping or squeezing.
///
/// ---
/// ### Call-site examples
///
/// Full button — leading icon + text + trailing icon:
/// ```dart
/// CommonButton(
///   onTap: onTap,
///   leadingIcon: Icons.google,
///   label: const Text('Sign in with Google'),
///   trailingIcon: Icons.arrow_forward,
/// )
/// ```
///
/// Small-width icon button (no overflow):
/// ```dart
/// CommonButton(
///   onTap: onTap,
///   shape: ButtonShape.iconOnly,
///   leadingIcon: Icons.arrow_forward,
///   width: MediaQuery.sizeOf(context).width * 0.1,
/// )
/// ```
///
/// Circle FAB:
/// ```dart
/// CommonButton.circle(
///   onTap: onTap,
///   leadingIcon: Icons.add,
///   fixedSize: 56,
/// )
/// ```
///
/// Image logo + text:
/// ```dart
/// CommonButton(
///   onTap: onTap,
///   leadingImage: const AssetImage('assets/google.png'),
///   label: const Text('Sign in with Google'),
/// )
/// ```
///
/// Loading state:
/// ```dart
/// CommonButton(onTap: onTap, label: const Text('Save'), isLoading: true)
/// ```
class CommonButton2 extends StatelessWidget {
  const CommonButton2({
    super.key,
    required this.onTap,
    this.label,
    // ── Leading slot ──────────────────────────────────────────────────────
    this.leadingIcon,
    this.leadingIconSize = 20.0,
    this.leadingImage,
    this.leadingImageSize = 22.0,
    this.leadingWidget,
    // ── Trailing slot ─────────────────────────────────────────────────────
    this.trailingIcon,
    this.trailingIconSize = 20.0,
    this.trailingImage,
    this.trailingImageSize = 22.0,
    this.trailingWidget,
    // ── Appearance ────────────────────────────────────────────────────────
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.borderRadius,
    // ── Sizing ────────────────────────────────────────────────────────────
    this.width,
    this.height,
    this.padding,
    this.gapBetweenSlots = 8.0,
    // ── State ─────────────────────────────────────────────────────────────
    this.isLoading = false,
    this.shape = ButtonShape.rounded,
  }) : fixedSize = null;

  /// Circle variant — leading slot centred inside a circular container.
  const CommonButton2.circle({
    super.key,
    required this.onTap,
    this.leadingIcon,
    this.leadingIconSize = 24.0,
    this.leadingImage,
    this.leadingImageSize = 24.0,
    this.leadingWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.fixedSize = 48,
    this.isLoading = false,
  })  : shape = ButtonShape.circle,
        label = null,
        trailingIcon = null,
        trailingIconSize = 0,
        trailingImage = null,
        trailingImageSize = 0,
        trailingWidget = null,
        borderRadius = null,
        width = null,
        height = null,
        padding = null,
        gapBetweenSlots = 0;

  /// Icon-only variant — leading slot centred inside a rounded rectangle.
  /// Use when [width] is small and you want a single icon with no overflow.
  const CommonButton2.iconOnly({
    super.key,
    required this.onTap,
    this.leadingIcon,
    this.leadingIconSize = 20.0,
    this.leadingImage,
    this.leadingImageSize = 22.0,
    this.leadingWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.borderRadius,
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
  })  : shape = ButtonShape.iconOnly,
        label = null,
        trailingIcon = null,
        trailingIconSize = 0,
        trailingImage = null,
        trailingImageSize = 0,
        trailingWidget = null,
        fixedSize = null,
        gapBetweenSlots = 0;

  // ── Callbacks ─────────────────────────────────────────────────────────────

  /// Null → disabled automatically. No separate flag needed.
  final VoidCallback? onTap;

  // ── Content ───────────────────────────────────────────────────────────────

  final Widget? label;

  // Leading
  /// Renders an [Icon] on the left. Priority: icon > image > widget.
  final IconData? leadingIcon;
  final double leadingIconSize;

  /// Renders an [Image] on the left via any [ImageProvider].
  final ImageProvider? leadingImage;
  final double leadingImageSize;

  /// Raw widget fallback for the left slot (SvgPicture, Lottie, etc.).
  final Widget? leadingWidget;

  // Trailing
  /// Renders an [Icon] on the right. Priority: icon > image > widget.
  final IconData? trailingIcon;
  final double trailingIconSize;

  /// Renders an [Image] on the right via any [ImageProvider].
  final ImageProvider? trailingImage;
  final double trailingImageSize;

  /// Raw widget fallback for the right slot.
  final Widget? trailingWidget;

  // ── Appearance ────────────────────────────────────────────────────────────

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadiusGeometry? borderRadius;

  // ── Sizing ────────────────────────────────────────────────────────────────

  /// Diameter for [ButtonShape.circle].
  final double? fixedSize;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double gapBetweenSlots;

  // ── State ─────────────────────────────────────────────────────────────────

  final bool isLoading;
  final ButtonShape shape;

  // ── Private ───────────────────────────────────────────────────────────────

  bool get _isDisabled => onTap == null;
  bool get _isInteractive => !_isDisabled && !isLoading;

  Color _resolveBackground(BuildContext context) => _isDisabled
      ? Colors.grey
      : (backgroundColor ?? Colors.orange);

  Color _resolveForeground() => _isDisabled
      ? Colors.grey.shade600
      : (foregroundColor ?? Colors.white);

  BoxDecoration _buildDecoration(BuildContext context) => BoxDecoration(
    color: _resolveBackground(context),
    shape: shape == ButtonShape.circle
        ? BoxShape.circle
        : BoxShape.rectangle,
    borderRadius: shape == ButtonShape.circle
        ? null
        : (borderRadius ?? BorderRadius.circular(12)),
    border: borderColor != null
        ? Border.all(color: borderColor!, width: borderWidth)
        : null,
  );

  Widget? _resolveLeading(Color fg) {
    if (leadingIcon != null) {
      return Icon(leadingIcon, size: leadingIconSize, color: fg);
    }
    if (leadingImage != null) {
      return Image(
        image: leadingImage!,
        width: leadingImageSize,
        height: leadingImageSize,
        fit: BoxFit.contain,
      );
    }
    return leadingWidget;
  }

  Widget? _resolveTrailing(Color fg) {
    if (trailingIcon != null) {
      return Icon(trailingIcon, size: trailingIconSize, color: fg);
    }
    if (trailingImage != null) {
      return Image(
        image: trailingImage!,
        width: trailingImageSize,
        height: trailingImageSize,
        fit: BoxFit.contain,
      );
    }
    return trailingWidget;
  }

  Widget _buildContent(BuildContext context, Color fg) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    }

    // circle and iconOnly: only the leading slot, centred — nothing else.
    if (shape == ButtonShape.circle || shape == ButtonShape.iconOnly) {
      return _resolveLeading(fg) ?? const SizedBox.shrink();
    }

    // rounded: full leading + label + trailing row.
    final leading = _resolveLeading(fg);
    final trailing = _resolveTrailing(fg);
    final hasLeading = leading != null;
    final hasLabel = label != null;
    final hasTrailing = trailing != null;

    if (!hasLeading && !hasLabel && !hasTrailing) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasLeading) leading,
        if (hasLeading && hasLabel) SizedBox(width: gapBetweenSlots),
        if (hasLabel) Flexible(child: label!),
        if (hasTrailing && (hasLeading || hasLabel))
          SizedBox(width: gapBetweenSlots),
        if (hasTrailing) trailing,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fg = _resolveForeground();
    final isCircle = shape == ButtonShape.circle;
    final isIconOnly = shape == ButtonShape.iconOnly;

    EdgeInsetsGeometry? resolvedPadding;
    if (isCircle || isIconOnly) {
      resolvedPadding = null; // no padding — alignment: center handles it
    } else {
      resolvedPadding = padding ??
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    }

    return GestureDetector(
      onTap: _isInteractive ? onTap : null,
      child: Container(
        width: isCircle ? fixedSize : width,
        height: isCircle ? fixedSize : height,
        padding: resolvedPadding,
        decoration: _buildDecoration(context),
        alignment: Alignment.center,
        child: IconTheme(
          data: IconThemeData(color: fg, size: 20),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: fg, fontWeight: FontWeight.w600),
            child: _buildContent(context, fg),
          ),
        ),
      ),
    );
  }
}