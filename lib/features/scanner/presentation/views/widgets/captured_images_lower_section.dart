import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/core/utils/constants.dart';
import 'package:scanify_pdf/core/utils/size_extensions.dart';
import 'package:scanify_pdf/core/utils/styles.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/widgets/save_pdf_bottom_sheet.dart';

class CapturedImagesLowerSection extends StatelessWidget {
  final String? fileIdToEdit;
  final String? pdfNameToEdit;

  const CapturedImagesLowerSection({
    super.key,
    this.fileIdToEdit,
    this.pdfNameToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s32,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF202334),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          final scannerCubit = context.read<ScannerCubit>();

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BlocProvider.value(
                value: scannerCubit,
                child: SavePdfBottomSheet(
                  fileIdToEdit: fileIdToEdit,
                  pdfNameToEdit: pdfNameToEdit,
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          fixedSize: Size(double.infinity, context.h * 0.07),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          fileIdToEdit != null ? 'Update PDF' : 'Convert to PDF',
          style: Styles.textStyle18.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
