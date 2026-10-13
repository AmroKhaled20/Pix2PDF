import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/core/utils/styles.dart';

class CapturedImagesAppBar extends StatelessWidget {
  final bool isEditMode;
  const CapturedImagesAppBar({super.key, this.isEditMode = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s16,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSpacing.s16),
          Text(
            isEditMode ? 'Edit PDF' : 'Review Images',
            style: Styles.titleMeduim.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
