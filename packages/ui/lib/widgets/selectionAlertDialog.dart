import 'package:flutter/material.dart';
import 'package:ui/extensions/text_style_extension.dart';

import '../constants/app_colors.dart';
import 'common_btn.dart';
import 'common_text_button.dart';

/// A generic bottom-sheet selection dialog.
///
/// ### What's new vs the original
/// - [topImage] — optional illustration above the header, matching the update
///   dialog style (image 2). When provided it sits above the coloured header.
/// - [textButtonLabel] / [onTextButtonTap] — optional text link below the
///   add-button, matching the "هل نسيت كلمه المرور؟" pattern (image 1).
/// - [addButtonLabel] / [onAddTap] — unchanged, still renders a [CommonButton].
/// - Everything else is unchanged from the original.
class SelectionAlertDialog<T> extends StatefulWidget {
  const SelectionAlertDialog({
    super.key,
    required this.headerTitle,
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    // ── Top visual ────────────────────────────────────────────────────────
    this.topImage,
    this.topImageHeight = 180.0,
    // ── Header ────────────────────────────────────────────────────────────
    this.showProfile = false,
    this.avatarBuilder,
    this.headerLeading,
    this.headerSubtitle,
    // ── Add button (optional) ─────────────────────────────────────────────
    this.addButtonLabel,
    this.onAddTap,
    // ── Text button below add button (optional) ───────────────────────────
    this.textButtonLabel,
    this.onTextButtonTap,
    this.textButtonUnderlined = false,
    this.textButtonColor,
  }) : assert(
  !showProfile || avatarBuilder != null,
  'Provide avatarBuilder when showProfile is true',
  );

  // Top visual
  final ImageProvider? topImage;
  final double topImageHeight;

  // Header
  final String headerTitle;
  final bool showProfile;
  final Widget Function(T item)? avatarBuilder;
  final Widget? headerLeading;
  final String? headerSubtitle;

  // List
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) labelBuilder;

  // Add button
  final String? addButtonLabel;
  final VoidCallback? onAddTap;

  // Text button
  final String? textButtonLabel;
  final VoidCallback? onTextButtonTap;
  final bool textButtonUnderlined;
  final Color? textButtonColor;

  @override
  State<SelectionAlertDialog<T>> createState() =>
      _SelectionAlertDialogState<T>();
}

class _SelectionAlertDialogState<T> extends State<SelectionAlertDialog<T>> {
  late T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    final hasTopImage = widget.topImage != null;
    final hasAddButton = widget.addButtonLabel != null;
    final hasTextButton = widget.textButtonLabel != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Optional top image ─────────────────────────────────────────
          if (hasTopImage)
            Image(
              image: widget.topImage!,
              width: double.infinity,
              height: widget.topImageHeight,
              fit: BoxFit.cover,
            ),

          // ── Coloured header ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            color: AppColors.primaryColor,
            child: widget.showProfile
                ? Row(
              textDirection: TextDirection.rtl,
              children: [
                if (widget.headerLeading != null) widget.headerLeading!,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.headerTitle,
                        style: context
                            .textStyleSemiBold()
                            .copyWith(color: Colors.white),
                      ),
                      if (widget.headerSubtitle != null)
                        Text(
                          widget.headerSubtitle!,
                          style: context
                              .textStyleSmall()
                              .copyWith(color: Colors.white70),
                        ),
                    ],
                  ),
                ),
              ],
            )
                : Text(
              widget.headerTitle,
              style: context
                  .textStyleSemiBold()
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          // ── Items list ─────────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            itemCount: widget.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isSelected = item == _selected;
              return _SelectionItem<T>(
                item: item,
                label: widget.labelBuilder(item),
                isSelected: isSelected,
                showProfile: widget.showProfile,
                avatarBuilder: widget.avatarBuilder,
                onTap: () {
                  setState(() => _selected = item);
                  Future.delayed(const Duration(milliseconds: 150), () {
                    if (context.mounted) Navigator.pop(context, item);
                  });
                },
              );
            },
          ),

          // ── Add button ─────────────────────────────────────────────────
          if (hasAddButton)
            Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, hasTextButton ? 8 : 12),
              child: CommonButton2(
                onTap: widget.onAddTap,
                leadingIcon: Icons.add,
                label: Text(
                  widget.addButtonLabel!,
                  style:
                  context.textStyleRegular().copyWith(color: Colors.white),
                ),
              ),
            ),

          // ── Text button ────────────────────────────────────────────────
          if (hasTextButton)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: CommonTextButton(
                onTap: widget.onTextButtonTap,
                underlined: widget.textButtonUnderlined,
                color: widget.textButtonColor,
                label: Text(
                  widget.textButtonLabel!,
                  style: context.textStyleRegular(),
                ),
              ),
            ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}

// ── Private item widget ──────────────────────────────────────────────────────
// Unchanged from original.

class _SelectionItem<T> extends StatelessWidget {
  const _SelectionItem({
    required this.item,
    required this.label,
    required this.isSelected,
    required this.showProfile,
    required this.onTap,
    this.avatarBuilder,
  });

  final T item;
  final String label;
  final bool isSelected;
  final bool showProfile;
  final VoidCallback onTap;
  final Widget Function(T)? avatarBuilder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.08)
              : Colors.white,
          border: Border.all(
            color:
            isSelected ? AppColors.primaryColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade400,
                  width: 1.5,
                ),
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: context.textStyleRegular().copyWith(
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.black87,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (showProfile && avatarBuilder != null) ...[
              const SizedBox(width: 8),
              avatarBuilder!(item),
            ],
          ],
        ),
      ),
    );
  }
}