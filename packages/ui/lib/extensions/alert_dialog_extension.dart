import 'package:flutter/material.dart';

import '../widgets/confirm_alert_dialog.dart';
import '../widgets/selectionAlertDialog.dart';

extension AlertDialogExtension on BuildContext {
  // ── Confirm dialogs ─────────────────────────────────────────────────────

  Future<void> showWarningDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
    IconData confirmIcon = Icons.arrow_back,
    String? textButtonLabel,
    VoidCallback? onTextButton,
  }) =>
      showDialog<void>(
        context: this,
        barrierDismissible: true,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.warning(
            title: title,
            body: body,
            confirmLabel: confirmLabel,
            onConfirm: onConfirm,
            confirmIcon: confirmIcon,
            textButtonLabel: textButtonLabel,
            onTextButton: onTextButton,
          ),
        ),
      );

  Future<void> showErrorDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) =>
      showDialog<void>(
        context: this,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.error(
            title: title,
            body: body,
            confirmLabel: confirmLabel,
            onConfirm: onConfirm,
          ),
        ),
      );

  Future<void> showSuccessDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) =>
      showDialog<void>(
        context: this,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.success(
            title: title,
            body: body,
            confirmLabel: confirmLabel,
            onConfirm: onConfirm,
          ),
        ),
      );

  Future<void> showChoiceDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) =>
      showDialog<void>(
        context: this,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.choice(
            title: title,
            body: body,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
        ),
      );

  Future<void> showDestructiveDialog({
    required String title,
    required String body,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) =>
      showDialog<void>(
        context: this,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.destructive(
            title: title,
            body: body,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
        ),
      );

  Future<void> showUpdateDialog({
    required String title,
    required String body,
    required ImageProvider illustration,
    required String updateLabel,
    required VoidCallback onUpdate,
    VoidCallback? onLater,
    String laterLabel = 'لاحقًا',
  }) =>
      showDialog<void>(
        context: this,
        barrierDismissible: onLater != null,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.update(
            title: title,
            body: body,
            illustration: illustration,
            updateLabel: updateLabel,
            onUpdate: onUpdate,
            onLater: onLater,
            laterLabel: laterLabel,
          ),
        ),
      );

  Future<void> showBiometricDialog({
    required String title,
    required VoidCallback onCancel,
    String cancelLabel = 'إلغاء',
    IconData icon = Icons.fingerprint,
  }) =>
      showDialog<void>(
        context: this,
        barrierDismissible: false,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: ConfirmAlertDialog.biometric(
            title: title,
            onCancel: onCancel,
            cancelLabel: cancelLabel,
            icon: icon,
          ),
        ),
      );

  // ── Selection dialogs ───────────────────────────────────────────────────

  Future<T?> showOptionsPicker<T>({
    required String headerTitle,
    required List<T> items,
    required T? selectedItem,
    required String Function(T item) labelBuilder,
    String? applyButtonLabel,
    VoidCallback? onApplyTap,
  }) =>
      showModalBottomSheet<T>(
        context: this,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: SelectionAlertDialog<T>.options(
            headerTitle: headerTitle,
            items: items,
            selectedItem: selectedItem,
            labelBuilder: labelBuilder,
            applyButtonLabel: applyButtonLabel,
            onApplyTap: onApplyTap,
          ),
        ),
      );

  Future<T?> showProfilePicker<T>({
    required String headerTitle,
    required List<T> items,
    required T? selectedItem,
    required String Function(T item) labelBuilder,
    required Widget Function(T item) avatarBuilder,
    Widget? headerLeading,
    String? headerSubtitle,
    String? addButtonLabel,
    VoidCallback? onAddTap,
    String? textButtonLabel,
    VoidCallback? onTextButtonTap,
  }) =>
      showModalBottomSheet<T>(
        context: this,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: SelectionAlertDialog<T>.withProfile(
            headerTitle: headerTitle,
            items: items,
            selectedItem: selectedItem,
            labelBuilder: labelBuilder,
            avatarBuilder: avatarBuilder,
            headerLeading: headerLeading,
            headerSubtitle: headerSubtitle,
            addButtonLabel: addButtonLabel,
            onAddTap: onAddTap,
            textButtonLabel: textButtonLabel,
            onTextButtonTap: onTextButtonTap,
          ),
        ),
      );
}