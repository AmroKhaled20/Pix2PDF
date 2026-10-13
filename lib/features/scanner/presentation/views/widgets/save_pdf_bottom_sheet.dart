import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanify_pdf/core/utils/app_router.dart';
import 'package:scanify_pdf/core/utils/app_spacing.dart';
import 'package:scanify_pdf/core/utils/constants.dart';
import 'package:scanify_pdf/core/utils/custom_snackbar.dart';
import 'package:scanify_pdf/core/utils/styles.dart';
import 'package:scanify_pdf/features/home/presentation/manager/home%20cubit/home_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';

class SavePdfBottomSheet extends StatefulWidget {
  final String? fileIdToEdit;
  final String? pdfNameToEdit;

  const SavePdfBottomSheet({super.key, this.fileIdToEdit, this.pdfNameToEdit});

  @override
  State<SavePdfBottomSheet> createState() => _SavePdfBottomSheetState();
}

class _SavePdfBottomSheetState extends State<SavePdfBottomSheet> {
  late TextEditingController _nameController;
  late String _defaultName;

  @override
  void initState() {
    super.initState();

    if (widget.pdfNameToEdit != null) {
      _defaultName = widget.pdfNameToEdit!;
    } else {
      final now = DateTime.now();
      _defaultName =
          'Scanify_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}';
    }

    _nameController = TextEditingController(text: _defaultName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScannerCubit, ScannerState>(
      listener: (context, state) {
        if (state is ScannerPdfGenerationSuccess) {
          context.read<ScannerCubit>().clearSession();
          context.read<HomeCubit>().fetchSavedFiles();

          CustomSnackbar.showSuccess(
            context,
            widget.fileIdToEdit != null
                ? 'PDF updated successfully!'
                : 'Converted to PDF successfully!',
          );

          if (widget.fileIdToEdit != null) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else {
            final router = GoRouter.of(context);
            router.pop();
            router.go(AppRouter.kHomeView);
          }
        } else if (state is ScannerPdfGenerationError) {
          CustomSnackbar.showError(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.s24),
            decoration: const BoxDecoration(
              color: Color(0xFF202334),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.fileIdToEdit != null
                          ? 'Update PDF'
                          : 'Convert to PDF',
                      style: Styles.titleMeduim.copyWith(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => GoRouter.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s32),
                TextField(
                  controller: _nameController,
                  style: Styles.textStyle16.copyWith(color: Colors.white),
                  cursorColor: primaryColor,
                  enabled: state is! ScannerPdfGenerationLoading,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () => _nameController.clear(),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s40),
                ElevatedButton(
                  onPressed: state is ScannerPdfGenerationLoading
                      ? null
                      : () {
                          String fileName = _nameController.text.trim();

                          if (fileName.isEmpty) {
                            fileName = _defaultName;
                          }

                          if (widget.fileIdToEdit != null) {
                            context.read<ScannerCubit>().updateExistingPdf(
                              fileId: widget.fileIdToEdit!,
                              fileName: fileName,
                            );
                          } else {
                            context.read<ScannerCubit>().generatePdf(fileName);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    fixedSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state is ScannerPdfGenerationLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.fileIdToEdit != null ? 'UPDATE' : 'CONVERT',
                          style: Styles.textStyle18.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: AppSpacing.s16),
              ],
            ),
          ),
        );
      },
    );
  }
}
