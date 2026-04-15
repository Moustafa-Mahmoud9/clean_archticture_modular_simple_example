import 'package:flutter/material.dart';
import 'package:ui/extensions/text_style_extension.dart';

import '../constants/app_colors.dart';
import 'common_btn.dart';
import 'common_text_button.dart';

/// A flexible confirmation dialog.
///
/// Supports:
/// - Optional top illustration image ([topImage]) — shown above the title,
///   as seen in the update dialogs (image 2).
/// - Optional top icon ([topIcon]) — shown above the title when no image
///   is provided, as seen in the warning dialog (image 1).
/// - Primary action button (always shown).
/// - Optional secondary action button shown beside the primary ([showSecondButton]).
/// - Optional text button below the main button row ([textButtonLabel]) —
///   as seen in the "هل نسيت كلمه المرور؟" link in image 1.
///
/// ### Examples
///
/// Warning dialog with icon + text button (image 1 style):
/// ```dart
/// ConfirmAlertDialog(
///   topIcon: Icons.warning_amber_rounded,
///   title: 'هذا الجهاز مرتبط بحساب بالفعل',
///   body: 'لا يمكن إنشاء حساب جديد على هذا الجهاز.',
///   confirmLabel: 'تسجيل الدخول',
///   confirmIcon: Icons.arrow_back,
///   onTapFirstButton: onLogin,
///   textButtonLabel: 'هل نسيت كلمه المرور؟',
///   onTapTextButton: onForgotPassword,
///   textButtonUnderlined: true,
/// )
/// ```
///
/// Update dialog with illustration + two buttons (image 2 left style):
/// ```dart
/// ConfirmAlertDialog(
///   topImage: const AssetImage('assets/update_illustration.png'),
///   title: 'يتوفر إصدار أحدث',
///   body: 'احصل على تجربة أفضل وميزات جديدة.',
///   confirmLabel: 'تحديث الآن',
///   onTapFirstButton: onUpdate,
///   showSecondButton: true,
///   cancelLabel: 'لاحقًا',
///   onTapSecondButton: onLater,
/// )
/// ```
class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.onTapFirstButton,
    // ── Top visual (pick one) ──────────────────────────────────────────────
    this.topIcon,
    this.topIconColor,
    this.topIconSize = 48.0,
    this.topImage,
    this.topImageHeight = 180.0,
    // ── Primary button ────────────────────────────────────────────────────
    this.confirmIcon,
    this.isDangerous = false,
    this.iconColor,
    // ── Second button (optional) ──────────────────────────────────────────
    this.showSecondButton = false,
    this.cancelLabel,
    this.onTapSecondButton,
    // ── Text button below buttons (optional) ──────────────────────────────
    this.textButtonLabel,
    this.onTapTextButton,
    this.textButtonUnderlined = false,
    this.textButtonColor,
    // ── Dismiss ───────────────────────────────────────────────────────────
    this.canDismiss = true,
    this.bodyStyle,
    this.titleStyle, this.secondButtonColor, this.firstButtonColor,
  }) : assert(
          topIcon == null || topImage == null,
          'Provide either topIcon or topImage, not both.',
        );

  final String title;
  final String body;
  final TextStyle? bodyStyle;
  final TextStyle? titleStyle;

  // Top visual — mutually exclusive
  final IconData? topIcon;
  final Color? topIconColor;
  final double topIconSize;
  final ImageProvider? topImage;
  final double topImageHeight;

  // Primary button
  final String confirmLabel;
  final VoidCallback? onTapFirstButton;
  final IconData? confirmIcon;
  final bool isDangerous;
  final Color? iconColor;

  // Second button
  final bool showSecondButton;
  final String? cancelLabel;
  final VoidCallback? onTapSecondButton;
  final Color? secondButtonColor;
  final Color? firstButtonColor;

  // Text button
  final String? textButtonLabel;
  final VoidCallback? onTapTextButton;
  final bool textButtonUnderlined;
  final Color? textButtonColor;

  final bool canDismiss;

  @override
  Widget build(BuildContext context) {
    final hasTopImage = topImage != null;
    final hasTopIcon = topIcon != null && !hasTopImage;
    final hasTextButton = textButtonLabel != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      // When there's a top image, remove top padding so image bleeds to edge.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top image ────────────────────────────────────────────────
            if (hasTopImage)
              Image(
                image: topImage!,
                width: double.infinity,
                height: topImageHeight,
                fit: BoxFit.contain,
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                hasTopImage ? 20 : 28, // less top gap when image is above
                20,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top icon ───────────────────────────────────────────
                  if (hasTopIcon) ...[
                    Icon(
                      topIcon,
                      size: topIconSize,
                      color: topIconColor ?? Colors.black87,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Title ──────────────────────────────────────────────
                  Text(
                    title,
                    style: titleStyle ??
                        context
                            .textStyleSemiBold()
                            .copyWith(fontSize: 17, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // ── Body ───────────────────────────────────────────────
                  Text(
                    body,
                    style: bodyStyle ??
                        context.textStyleRegular().copyWith(
                              height: 1.7,
                              color: Colors.grey.shade600,
                            ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 16),

                  // ── Button row ─────────────────────────────────────────
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: CommonButton2(
                          onTap: onTapFirstButton,
                          backgroundColor:firstButtonColor ??
                               AppColors.redColor,
                          trailingIcon: confirmIcon,
                          foregroundColor: iconColor ?? Colors.white,
                          label: Text(
                            confirmLabel,
                            style: context
                                .textStyleSemiBold()
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      if (showSecondButton) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: CommonButton2(
                            onTap: onTapSecondButton,
                            label: Text(cancelLabel ?? 'إلغاء'),
                            backgroundColor:secondButtonColor,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ── Text button ────────────────────────────────────────
                  if (hasTextButton) ...[
                    const SizedBox(height: 14),
                    CommonTextButton(
                      onTap: onTapTextButton,
                      underlined: textButtonUnderlined,
                      color: textButtonColor,
                      label: Text(
                        textButtonLabel!,
                        style: context.textStyleRegular(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
