import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:scanify_pdf/core/errors/failure.dart';
import 'package:scanify_pdf/core/models/pdf_file_model.dart';
import 'package:scanify_pdf/features/scanner/data/data_sources/scanner_local_data_source.dart';
import 'package:scanify_pdf/features/scanner/domain/entities/scanned_image_entity.dart';
import 'package:scanify_pdf/features/scanner/domain/repos/scanner_repo.dart';
import 'package:scanify_pdf/core/utils/pdf_generator_util.dart';

class ScannerRepoImpl implements ScannerRepo {
  final ScannerLocalDataSource localDataSource;

  ScannerRepoImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> generateAndSavePdf({
    required List<ScannedImageEntity> images,
    required String pdfName,
  }) async {
    try {
      if (images.isEmpty) {
        return Left(EmptyImagesFailure());
      }

      final imagePaths = images.map((e) => e.imagePath).toList();

      final pdfModel = await PdfGeneratorUtil.generate(
        imagePaths: imagePaths,
        pdfName: pdfName,
      );

      await localDataSource.savePdfMetadata(pdfModel);

      return const Right(null);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (e is PathNotFoundException || errorString.contains('no such file')) {
        return Left(ImageNotFoundFailure());
      } else if (e is FileSystemException) {
        return Left(
          FileSystemFailure('Storage error. Please check your space.'),
        );
      } else if (errorString.contains('hive') || errorString.contains('box')) {
        return Left(LocalDatabaseFailure('Failed to save file data.'));
      } else {
        return Left(PdfGenerationFailure('Failed to create PDF.'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> clearCachedImages({
    required List<ScannedImageEntity> images,
  }) async {
    try {
      for (final image in images) {
        final file = File(image.imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      return const Right(null);
    } catch (e) {
      if (e is FileSystemException) {
        return Left(FileSystemFailure('Failed to clear some cached images.'));
      }
      return Left(UnknownFailure('Something went wrong. Try again.'));
    }
  }

  @override
  Future<Either<Failure, List<ScannedImageEntity>>>
  pickImagesFromGallery() async {
    try {
      final imagePaths = await localDataSource.pickImagesFromGallery();

      if (imagePaths.isEmpty) {
        return const Right([]);
      }

      final List<ScannedImageEntity> images = imagePaths.map((path) {
        return ScannedImageEntity(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          imagePath: path,
        );
      }).toList();

      return Right(images);
    } catch (e) {
      return Left(UnknownFailure('Failed to load images from gallery.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateExistingPdf({
    required List<ScannedImageEntity> images,
    required String pdfName,
    required String fileId,
  }) async {
    try {
      final oldPdfData = localDataSource.getPdfById(fileId);

      if (oldPdfData == null) {
        return Left(DatabaseFailure('Original PDF file not found.'));
      }

      final imagePaths = images.map((e) => e.imagePath).toList();

      final oldPdfFile = File(oldPdfData.pdfPath);
      if (oldPdfFile.existsSync()) {
        oldPdfFile.deleteSync();
      }

      final newPdfModel = await PdfGeneratorUtil.generate(
        imagePaths: imagePaths,
        pdfName: pdfName,
      );

      for (var oldImagePath in oldPdfData.imagePaths) {
        final oldImgFile = File(oldImagePath);
        if (oldImgFile.existsSync()) {
          oldImgFile.deleteSync();
        }
      }

      final updatedPdfModel = PdfFileModel(
        id: fileId,
        name: newPdfModel.name,
        numOfPages: newPdfModel.numOfPages,
        thumbnailPath: newPdfModel.thumbnailPath,
        size: newPdfModel.size,
        createdAt: oldPdfData.createdAt,
        pdfPath: newPdfModel.pdfPath,
        imagePaths: newPdfModel.imagePaths,
      );

      await localDataSource.savePdfMetadata(updatedPdfModel);

      return const Right(null);
    } catch (e) {
      return Left(PdfGenerationFailure('Failed to update PDF'));
    }
  }
}
