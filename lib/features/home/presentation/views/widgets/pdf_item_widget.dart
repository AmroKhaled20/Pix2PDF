import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scanify_pdf/core/entities/pdf_file_entity.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/core/utils/size_extensions.dart';
import 'package:scanify_pdf/core/utils/styles.dart';
import 'package:scanify_pdf/features/home/presentation/views/widgets/file_options_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

class PdfItemWidget extends StatelessWidget {
  final PdfFileEntity pdfFile;
  final bool isSelectionMode;
  final bool isSelected;

  const PdfItemWidget({
    super.key,
    required this.pdfFile,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.w * 0.23,
            height: context.w * 0.23,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    image: pdfFile.thumbnailPath != null
                        ? DecorationImage(
                            image: ResizeImage(
                              FileImage(File(pdfFile.thumbnailPath!)),
                              width: 200,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9E9E9E),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pdfFile.name,
                  style: Styles.textStyle18.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A4E69),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pdfFile.numOfPages.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),

                    Text(
                      pdfFile.createdAt.toString().split(' ')[0],
                      style: Styles.textStyle14.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: AppSpacing.s16),

                    Expanded(
                      child: Text(
                        pdfFile.size,
                        style: Styles.textStyle14.copyWith(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                isSelectionMode
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF5A6BFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF5A6BFF)
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final file = XFile(pdfFile.pdfPath);
                              await SharePlus.instance.share(
                                ShareParams(files: [file]),
                              );
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Colors.grey,
                              size: 22,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(width: AppSpacing.s24),
                          IconButton(
                            onPressed: () {
                              showFileOptionsBottomSheet(context, pdfFile);
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                              size: 22,
                            ),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
