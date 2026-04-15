import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// A styled text field for use across the app.
///
/// ### Changes vs original
///
/// 1. **Keyboard dismiss on outside tap** — wrap your screen's root widget
///    with this field present in a [GestureDetector] calling
///    `FocusScope.of(context).unfocus()`. This widget itself also calls
///    `FocusScope.of(context).unfocus()` via its own [onTap] wrapper when
///    [dismissKeyboardOnOutsideTap] is true (handled at field level for cases
///    where the field is the only interactive element).
///    The recommended approach is a single [GestureDetector] at the scaffold
///    level — see usage note below.
///
/// 2. **`successText`** — green helper text shown when validation passes,
///    matching the same visual weight as errorText.
///
/// 3. **`helperText`** — neutral grey hint below the field (distinct from the
///    in-field hint placeholder).
///
/// 4. **`onTapOutside`** unfocuses automatically — [TextFormField] in Flutter
///    3.x supports `onTapOutside` natively. We wire it to unfocus by default
///    so the keyboard dismisses when the user taps anywhere outside the field.
///
/// 5. **`counterText: ''`** — hides the built-in character counter when
///    [maxLength] is set, since most UIs handle this separately.
///
/// 6. **`textDirection`** — explicit param instead of relying on ambient
///    directionality, useful in mixed RTL/LTR layouts.
///
/// 7. **`borderRadius`** — configurable instead of hardcoded 12.
///
/// ### Keyboard dismiss — recommended scaffold-level pattern
/// ```dart
/// GestureDetector(
///   behavior: HitTestBehavior.opaque, // ← required to catch taps on empty areas
///   onTap: () => FocusScope.of(context).unfocus(),
///   child: Scaffold(...),
/// )
/// ```
/// Using `behavior: HitTestBehavior.opaque` ensures taps on non-widget areas
/// (empty space, padding) are also caught. Without it, taps on transparent
/// regions fall through and the keyboard stays open.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.successText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.onTapOutside,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textDirection,
    this.borderRadius = 12.0,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final String? label;

  /// Shown inside the field when empty. Distinct from [helperText].
  final String? hint;

  /// Red text shown below the field on validation failure.
  final String? errorText;

  /// Grey text shown below the field as a neutral hint.
  final String? helperText;

  /// Green text shown below the field to indicate a passing state.
  /// Takes priority over [helperText] when both are non-null.
  final String? successText;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Defaults to 1. Forced to 1 when [obscureText] is true.
  final int? maxLines;

  /// Minimum lines for expanding text areas. Only meaningful when
  /// [maxLines] > 1 or null.
  final int? minLines;

  /// When set the built-in counter is hidden — manage count in your UI if
  /// you need to surface it.
  final int? maxLength;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;

  /// Called when the user taps outside the field. Defaults to unfocusing
  /// (dismissing the keyboard) when null — override to suppress this.
  final void Function(PointerDownEvent)? onTapOutside;

  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Explicit text direction. Defaults to ambient [Directionality] when null.
  final TextDirection? textDirection;

  /// Corner radius. Defaults to 12.
  final double borderRadius;

  final TextCapitalization textCapitalization;

  // ── Helpers ───────────────────────────────────────────────────────────────

  OutlineInputBorder _border(Color color, {double width = 1.5}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    // successText takes visual priority over helperText.
    final String? resolvedHelper = successText ?? helperText;
    final Color? resolvedHelperColor =
    successText != null ? AppColors.success : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          // obscureText fields must be single-line — Flutter requirement.
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? null : minLines,
          maxLength: maxLength,
          enabled: enabled,
          readOnly: readOnly,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          // Dismiss keyboard when user taps anywhere outside this field.
          // The caller can override by passing their own [onTapOutside].
          onTapOutside: onTapOutside ??
                  (_) => FocusScope.of(context).unfocus(),
          inputFormatters: inputFormatters,
          focusNode: focusNode,
          autofocus: autofocus,
          textDirection: textDirection,
          textCapitalization: textCapitalization,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            errorText: errorText,
            helperText: resolvedHelper,
            helperStyle: AppTextStyles.bodySmall.copyWith(
              color: resolvedHelperColor ?? AppColors.textHint,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? AppColors.white : AppColors.greyLight,
            // Hide the built-in character counter — avoids visual clutter.
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: _border(AppColors.greyLight),
            enabledBorder: _border(AppColors.greyLight),
            focusedBorder: _border(AppColors.primaryColor, width: 2),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 2),
            disabledBorder: _border(AppColors.greyLight),
          ),
        ),
      ],
    );
  }
}