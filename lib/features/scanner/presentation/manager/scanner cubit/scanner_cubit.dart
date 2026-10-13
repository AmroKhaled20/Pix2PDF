import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:scanify_pdf/features/scanner/domain/entities/scanned_image_entity.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/clear_cached_images_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/generate_and_save_pdf_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/pick_images_from_gallery_use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/use_cases/update_existing_pdf_use_case.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  final GenerateAndSavePdfUseCase generateAndSavePdfUseCase;
  final ClearCachedImagesUseCase clearCachedImagesUseCase;
  final PickImagesFromGalleryUseCase pickImagesFromGalleryUseCase;
  final UpdateExistingPdfUseCase updateExistingPdfUseCase;

  List<ScannedImageEntity> capturedImages = [];

  ScannerCubit({
    required this.generateAndSavePdfUseCase,
    required this.clearCachedImagesUseCase,
    required this.pickImagesFromGalleryUseCase,
    required this.updateExistingPdfUseCase,
  }) : super(ScannerInitial());

  void addImage(String imagePath) {
    final newImage = ScannedImageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
    );
    capturedImages.add(newImage);
    emit(ScannerImagesUpdated(images: List.from(capturedImages)));
  }

  void removeImage(int index) {
    capturedImages.removeAt(index);
    emit(ScannerImagesUpdated(images: List.from(capturedImages)));
  }

  Future<void> generatePdf(String pdfName) async {
    emit(ScannerPdfGenerationLoading());

    final result = await generateAndSavePdfUseCase.call(
      GeneratePdfParams(images: capturedImages, pdfName: pdfName),
    );

    result.fold(
      (failure) =>
          emit(ScannerPdfGenerationError(errorMessage: failure.message)),
      (success) => emit(ScannerPdfGenerationSuccess()),
    );
  }

  Future<void> clearSession() async {
    await clearCachedImagesUseCase.call(
      ClearCacheParams(images: capturedImages),
    );
    capturedImages.clear();
    if (!isClosed) {
      emit(ScannerInitial());
    }
  }

  Future<void> pickImagesFromGallery() async {
    final result = await pickImagesFromGalleryUseCase.call();

    result.fold(
      (failure) =>
          emit(ScannerPdfGenerationError(errorMessage: failure.message)),
      (images) {
        if (images.isNotEmpty) {
          capturedImages.addAll(images);
          emit(ScannerImagesUpdated(images: List.from(capturedImages)));
        } else {
          emit(ScannerImagesUpdated(images: []));
        }
      },
    );
  }

  void loadImagesForEditing(List<String> imagePaths) {
    capturedImages.clear();

    for (var path in imagePaths) {
      capturedImages.add(
        ScannedImageEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imagePath: path,
        ),
      );
    }

    emit(ScannerImagesUpdated(images: List.from(capturedImages)));
  }

  Future<void> updateExistingPdf({
    required String fileId,
    required String fileName,
  }) async {
    emit(ScannerPdfGenerationLoading());

    final result = await updateExistingPdfUseCase.call(
      UpdatePdfParams(
        images: capturedImages,
        pdfName: fileName,
        fileId: fileId,
      ),
    );

    result.fold(
      (failure) =>
          emit(ScannerPdfGenerationError(errorMessage: failure.message)),
      (success) => emit(ScannerPdfGenerationSuccess()),
    );
  }
}
