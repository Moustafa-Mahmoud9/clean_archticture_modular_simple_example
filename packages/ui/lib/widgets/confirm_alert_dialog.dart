import 'package:flutter/material.dart';
import 'package:ui/extensions/text_style_extension.dart';

import '../constants/app_colors.dart';
import 'common_btn.dart';
import 'common_text_button.dart';

/// A flexible confirmation dialog.
///
/// Do NOT use the private constructor directly — use one of the named
/// factory constructors: [ConfirmAlertDialog.warning], [.error], [.success],
/// [.update], [.biometric], [.choice].
///
/// If none of the presets fit, add a new factory constructor here rather
/// than constructing the raw widget. This keeps every dialog in the app
/// consistent with the design system.
class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog._({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.onTapFirstButton,
    this.topIcon,
    this.topIconColor,
    this.topIconSize = 48.0,
    this.topImage,
    this.topImageHeight = 180.0,
    this.confirmIcon,
    this.isDangerous = false,
    this.iconColor,
    this.showSecondButton = false,
    this.cancelLabel,
    this.onTapSecondButton,
    this.textButtonLabel,
    this.onTapTextButton,
    this.textButtonUnderlined = false,
    this.textButtonColor,
    this.secondButtonColor,
    this.firstButtonColor,
    this.canDismiss = true,
    this.bodyStyle,
    this.titleStyle,
  }) : assert(
  topIcon == null || topImage == null,
  'Provide either topIcon or topImage, not both.',
  );

  // ── Named factory constructors ─────────────────────────────────────────
  //
  // Each factory below captures one design-approved dialog variant.
  // Keep their parameter lists minimal — expose only what a caller at the
  // use site actually needs to decide. Colors, icons, and styling come
  // from the design tokens.

  /// Warning dialog (image 6) — warning triangle, primary action with
  /// trailing arrow, optional underlined text link below.
  ///
  /// Example: "This device is already linked to an account."
  factory ConfirmAlertDialog.warning({
    Key? key,
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
    IconData confirmIcon = Icons.arrow_back,
    String? textButtonLabel,
    VoidCallback? onTextButton,
    bool canDismiss = true,
    Color? textButtonColor,
    TextStyle? bodyStyle,
    Color? secondButtonColor,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body: body,
        bodyStyle:bodyStyle,
        confirmLabel: confirmLabel,
        onTapFirstButton: onConfirm,
        topIcon: Icons.warning_amber_rounded,
        topIconColor: Colors.black87,
        confirmIcon: confirmIcon,
        firstButtonColor: AppColors.primaryColor,
        textButtonLabel: textButtonLabel,
        onTapTextButton: onTextButton,
        textButtonUnderlined: true,
        canDismiss: canDismiss,
        textButtonColor:textButtonColor,
        secondButtonColor: secondButtonColor,
      );

  /// Error dialog (image 2) — red warning mark, body text, single
  /// primary action (typically "retry" or "try again").
  factory ConfirmAlertDialog.error({
    Key? key,
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
    TextStyle? bodyStyle,
    bool canDismiss = true,
    Color? secondButtonColor,
    TextStyle? titleStyle,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body: body,
        confirmLabel:confirmLabel,
        onTapFirstButton:onConfirm,
        topIcon: Icons.error_outline,
        topIconColor: AppColors.redColor,
        firstButtonColor: Colors.white,
        iconColor: AppColors.primaryColor,
        titleStyle: titleStyle,
        canDismiss:canDismiss,
        bodyStyle:bodyStyle,
        secondButtonColor:secondButtonColor,
      );

  /// Success dialog (image 4) — green check icon, confirmation body,
  /// single primary action to continue.
  factory ConfirmAlertDialog.success({
    Key? key,
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
    bool canDismiss = true,
    TextStyle? bodyStyle,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        onTapFirstButton: onConfirm,
        topIcon: Icons.check_circle_outline,
        topIconColor: AppColors.success,
        firstButtonColor: AppColors.primaryColor,
        canDismiss: canDismiss,
        bodyStyle:bodyStyle,
      );

  /// Choice dialog (image 3) — two buttons side-by-side, no top visual.
  /// Primary action on the right (RTL layout), secondary outlined on left.
  ///
  /// Example: "Do you want to continue creating an account?"
  factory ConfirmAlertDialog.choice({
    Key? key,
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    bool canDismiss = true,
    TextStyle? bodyStyle,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onTapFirstButton: onConfirm,
        onTapSecondButton: onCancel,
        showSecondButton: true,
        firstButtonColor: AppColors.primaryColor,
        canDismiss: canDismiss,
        bodyStyle:bodyStyle,
      );

  /// Destructive choice — same layout as [.choice] but with a red primary
  /// button. Use for irreversible actions (delete account, etc.).
  factory ConfirmAlertDialog.destructive({
    Key? key,
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
    bool canDismiss = true,
    TextStyle? bodyStyle,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onTapFirstButton: onConfirm,
        onTapSecondButton: onCancel,
        showSecondButton: true,
        isDangerous: true,
        firstButtonColor: AppColors.redColor,
        topIcon: Icons.delete_outline,
        topIconColor: AppColors.redColor,
        canDismiss: canDismiss,
        bodyStyle: bodyStyle,
      );

  /// Update dialog (image 5) — illustration at top. Pass [onLater] to show
  /// a secondary "later" button; omit it to force the update (single button).
  factory ConfirmAlertDialog.update({
    Key? key,
    required String title,
    required String body,
    required ImageProvider illustration,
    required String updateLabel,
    required VoidCallback onUpdate,
    String laterLabel = 'لاحقًا',
    VoidCallback? onLater,
    double illustrationHeight = 180.0,
    TextStyle? bodyStyle,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body: body,
        confirmLabel: updateLabel,
        cancelLabel: laterLabel,
        onTapFirstButton: onUpdate,
        onTapSecondButton: onLater,
        topImage: illustration,
        topImageHeight: illustrationHeight,
        showSecondButton: onLater != null,
        firstButtonColor: AppColors.primaryColor,
        canDismiss: onLater != null,
        bodyStyle:bodyStyle,
      );

  /// Biometric prompt (image 1) — fingerprint icon, single outlined
  /// "cancel" button. Meant to be shown while a biometric scan is active.
  ///
  /// The dialog itself doesn't drive the biometric API — the caller does
  /// that and dismisses this dialog on success/failure.
  factory ConfirmAlertDialog.biometric({
    Key? key,
    required String title,
    required VoidCallback onCancel,
    String cancelLabel = 'إلغاء',
    IconData icon = Icons.fingerprint,
    TextStyle? bodyStyle,
    required String body,
  }) =>
      ConfirmAlertDialog._(
        key: key,
        title: title,
        body:body,
        bodyStyle:bodyStyle,
        confirmLabel:cancelLabel,
        onTapFirstButton:onCancel,
        topIcon: icon,
        topIconColor: AppColors.primaryColor,
        topIconSize: 56,
        firstButtonColor: Colors.white,
        iconColor: AppColors.primaryColor,
        canDismiss: false,
      );

  // ── Fields — exposed for build(), not for callers ──────────────────────

  final String title;
  final String body;
  final TextStyle? bodyStyle;
  final TextStyle? titleStyle;

  final IconData? topIcon;
  final Color? topIconColor;
  final double topIconSize;
  final ImageProvider? topImage;
  final double topImageHeight;

  final String confirmLabel;
  final VoidCallback? onTapFirstButton;
  final IconData? confirmIcon;
  final bool isDangerous;
  final Color? iconColor;

  final bool showSecondButton;
  final String? cancelLabel;
  final VoidCallback? onTapSecondButton;
  final Color? secondButtonColor;
  final Color? firstButtonColor;

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
    final hasBody = body.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                hasTopImage ? 20 : 28,
                20,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasTopIcon) ...[
                    Icon(
                      topIcon,
                      size: topIconSize,
                      color: topIconColor ?? Colors.black87,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    title,
                    style: titleStyle ??
                        context
                            .textStyleSemiBold()
                            .copyWith(fontSize: 17, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  if (hasBody) ...[
                    const SizedBox(height: 12),
                    Text(
                      body,
                      style: bodyStyle ??
                          context.textStyleRegular().copyWith(
                            height: 1.7,
                            color: Colors.grey.shade600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Expanded(
                        child: CommonButton2(
                          onTap: onTapFirstButton,
                          backgroundColor:
                          firstButtonColor ?? AppColors.redColor,
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
                            backgroundColor: secondButtonColor,
                          ),
                        ),
                      ],
                    ],
                  ),
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