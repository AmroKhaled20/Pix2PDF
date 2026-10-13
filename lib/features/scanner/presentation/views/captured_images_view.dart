import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanify_pdf/features/scanner/presentation/manager/scanner%20cubit/scanner_cubit.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/widgets/captured_images_app_bar.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/widgets/captured_images_grid.dart';
import 'package:scanify_pdf/features/scanner/presentation/views/widgets/captured_images_lower_section.dart';

class CapturedImagesView extends StatefulWidget {
  final List<String>? initialImages;
  final String? fileIdToEdit;
  final String? pdfNameToEdit;

  const CapturedImagesView({
    super.key,
    this.initialImages,
    this.fileIdToEdit,
    this.pdfNameToEdit,
  });

  @override
  State<CapturedImagesView> createState() => _CapturedImagesViewState();
}

class _CapturedImagesViewState extends State<CapturedImagesView> {
  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null && widget.initialImages!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ScannerCubit>().loadImagesForEditing(
          widget.initialImages!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CapturedImagesAppBar(isEditMode: widget.fileIdToEdit != null),

            const Expanded(child: CapturedImagesGrid()),

            CapturedImagesLowerSection(
              fileIdToEdit: widget.fileIdToEdit,
              pdfNameToEdit: widget.pdfNameToEdit,
            ),
          ],
        ),
      ),
    );
  }
}
