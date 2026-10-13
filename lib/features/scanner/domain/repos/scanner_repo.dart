import 'package:dartz/dartz.dart';
import 'package:scanify_pdf/core/errors/failure.dart';
import 'package:scanify_pdf/features/scanner/domain/entities/scanned_image_entity.dart';

abstract class ScannerRepo {
  Future<Either<Failure, void>> generateAndSavePdf({
    required List<ScannedImageEntity> images,
    required String pdfName,
  });

  Future<Either<Failure, void>> clearCachedImages({
    required List<ScannedImageEntity> images,
  });

  Future<Either<Failure, List<ScannedImageEntity>>> pickImagesFromGallery();

  Future<Either<Failure, void>> updateExistingPdf({
    required List<ScannedImageEntity> images,
    required String pdfName,
    required String fileId,
  });
}
