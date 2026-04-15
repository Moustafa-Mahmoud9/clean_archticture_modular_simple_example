import 'package:flutter/material.dart';

import '../widgets/confirm_alert_dialog.dart';
import '../widgets/selectionAlertDialog.dart';

extension AlertDialogExtension on BuildContext {
  Future<T?> showSelectionDialog<T>({
    required String headerTitle,
    required List<T> items,
    required T? selectedItem,
    required String Function(T item) labelBuilder,
    // ── Top visual ────────────────────────────────────────────────────────
    ImageProvider? topImage,
    double topImageHeight = 180.0,
    // ── Header ────────────────────────────────────────────────────────────
    bool showProfile = false,
    Widget Function(T item)? avatarBuilder,
    Widget? headerLeading,
    String? headerSubtitle,
    // ── Add button ────────────────────────────────────────────────────────
    String? addButtonLabel,
    VoidCallback? onAddTap,
    // ── Text button ───────────────────────────────────────────────────────
    String? textButtonLabel,
    VoidCallback? onTextButtonTap,
    bool textButtonUnderlined = false,
    Color? textButtonColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SelectionAlertDialog<T>(
        headerTitle: headerTitle,
        items: items,
        selectedItem: selectedItem,
        labelBuilder: labelBuilder,
        topImage: topImage,
        topImageHeight: topImageHeight,
        showProfile: showProfile,
        avatarBuilder: avatarBuilder,
        headerLeading: headerLeading,
        headerSubtitle: headerSubtitle,
        addButtonLabel: addButtonLabel,
        onAddTap: onAddTap,
        textButtonLabel: textButtonLabel,
        onTextButtonTap: onTextButtonTap,
        textButtonUnderlined: textButtonUnderlined,
        textButtonColor: textButtonColor,
      ),
    );
  }

  Future<void> showConfirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onTapFirstButton,
    // ── Top visual (pick one) ──────────────────────────────────────────────
    IconData? topIcon,
    Color? topIconColor,
    double topIconSize = 48.0,
    ImageProvider? topImage,
    double topImageHeight = 180.0,
    // ── Primary button ────────────────────────────────────────────────────
    IconData? confirmIcon,
    bool isDangerous = false,
    Color? iconColor,
    // ── Second button ─────────────────────────────────────────────────────
    bool showSecondButton = false,
    String? cancelLabel,
    VoidCallback? onTapSecondButton,
    // ── Text button ───────────────────────────────────────────────────────
    String? textButtonLabel,
    VoidCallback? onTapTextButton,
    bool textButtonUnderlined = false,
    Color? textButtonColor,
    Color? secondButtonColor,
    Color? firstButtonColor,
    // ── Dismiss ───────────────────────────────────────────────────────────
    bool canDismiss = true,
    final TextStyle? bodyStyle,
    final TextStyle? titleStyle,
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: canDismiss,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: ConfirmAlertDialog(
          title: title,
          body: body,
          confirmLabel: confirmLabel,
          onTapFirstButton: onTapFirstButton,
          topIcon: topIcon,
          topIconColor: topIconColor,
          topIconSize: topIconSize,
          topImage: topImage,
          topImageHeight: topImageHeight,
          confirmIcon: confirmIcon,
          isDangerous: isDangerous,
          iconColor: iconColor,
          showSecondButton: showSecondButton,
          cancelLabel: cancelLabel,
          onTapSecondButton: onTapSecondButton,
          textButtonLabel: textButtonLabel,
          onTapTextButton: onTapTextButton,
          textButtonUnderlined: textButtonUnderlined,
          textButtonColor: textButtonColor,
          canDismiss: canDismiss,
          bodyStyle: bodyStyle,
          titleStyle: titleStyle,
          secondButtonColor:secondButtonColor,
          firstButtonColor:firstButtonColor,
        ),
      ),
    );
  }
}
