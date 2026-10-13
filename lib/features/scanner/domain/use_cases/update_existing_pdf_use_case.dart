import 'package:dartz/dartz.dart';
import 'package:scanify_pdf/core/errors/failure.dart';
import 'package:scanify_pdf/core/use_cases/use_case.dart';
import 'package:scanify_pdf/features/scanner/domain/entities/scanned_image_entity.dart';
import 'package:scanify_pdf/features/scanner/domain/repos/scanner_repo.dart';

class UpdateExistingPdfUseCase extends UseCase<void, UpdatePdfParams> {
  final ScannerRepo scannerRepo;

  UpdateExistingPdfUseCase({required this.scannerRepo});

  @override
  Future<Either<Failure, void>> call(UpdatePdfParams param) async {
    if (param.images.isEmpty) {
      return Left(EmptyImagesFailure());
    }

    return await scannerRepo.updateExistingPdf(
      images: param.images,
      pdfName: param.pdfName,
      fileId: param.fileId,
    );
  }
}

class UpdatePdfParams {
  final List<ScannedImageEntity> images;
  final String pdfName;
  final String fileId;

  UpdatePdfParams({
    required this.images,
    required this.pdfName,
    required this.fileId,
  });
}
