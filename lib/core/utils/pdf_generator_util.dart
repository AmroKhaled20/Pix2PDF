import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:scanify_pdf/core/models/pdf_file_model.dart';

class PdfGeneratorUtil {
  static Future<PdfFileModel> generate({
    required List<String> imagePaths,
    required String pdfName,
  }) async {
    final pdf = pw.Document();

    const pageWidth = 595.28;

    for (final path in imagePaths) {
      final imageBytes = await File(path).readAsBytes();

      final decodedImage = await ui.instantiateImageCodec(imageBytes);
      final frame = await decodedImage.getNextFrame();

      final imageWidth = frame.image.width.toDouble();
      final imageHeight = frame.image.height.toDouble();

      final pageHeight = pageWidth * (imageHeight / imageWidth);

      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(pageWidth, pageHeight, marginAll: 0),
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.SizedBox(
              width: pageWidth,
              height: pageHeight,
              child: pw.Image(
                pdfImage,
                width: pageWidth,
                height: pageHeight,
                fit: pw.BoxFit.fill,
              ),
            );
          },
        ),
      );
    }

    final outputDir = await getApplicationDocumentsDirectory();
    final appPdfDir = Directory('${outputDir.path}/ScanifyPDFs');

    if (!await appPdfDir.exists()) {
      await appPdfDir.create(recursive: true);
    }

    final filePath = await _getUniqueFilePath(appPdfDir.path, pdfName);
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final finalPdfName = filePath.split('/').last.replaceAll('.pdf', '');

    List<String> persistentImagePaths = [];
    final uniqueId = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < imagePaths.length; i++) {
      final originalFile = File(imagePaths[i]);
      if (originalFile.existsSync()) {
        final persistentPath =
            '${appPdfDir.path}/$finalPdfName\_img_${uniqueId}_$i.jpg';
        await originalFile.copy(persistentPath);
        persistentImagePaths.add(persistentPath);
      }
    }

    String? savedThumbnailPath;
    if (persistentImagePaths.isNotEmpty) {
      savedThumbnailPath = persistentImagePaths.first;
    }

    final fileSizeInBytes = await file.length();

    return PdfFileModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: finalPdfName,
      numOfPages: persistentImagePaths.length,
      thumbnailPath: savedThumbnailPath,
      size: '${(fileSizeInBytes / 1024).toStringAsFixed(2)} KB',
      createdAt: DateTime.now(),
      pdfPath: filePath,
      imagePaths: persistentImagePaths,
    );
  }

  static Future<String> _getUniqueFilePath(
    String dirPath,
    String baseName,
  ) async {
    String filePath = '$dirPath/$baseName.pdf';
    File file = File(filePath);
    int counter = 1;

    while (await file.exists()) {
      filePath = '$dirPath/$baseName ($counter).pdf';
      file = File(filePath);
      counter++;
    }

    return filePath;
  }
}
