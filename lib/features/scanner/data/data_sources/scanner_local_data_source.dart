import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanify_pdf/core/models/pdf_file_model.dart';
import 'package:scanify_pdf/core/utils/constants.dart';

abstract class ScannerLocalDataSource {
  Future<void> savePdfMetadata(PdfFileModel pdfFile);
  Future<List<String>> pickImagesFromGallery();
  PdfFileModel? getPdfById(String id);
}

class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
  @override
  Future<void> savePdfMetadata(PdfFileModel pdfFile) async {
    var box = Hive.box(kPdfFilesBox);
    await box.put(pdfFile.id, pdfFile.toMap());
  }

  @override
  Future<List<String>> pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage(
      imageQuality: 100,
    );
    return pickedFiles.map((file) => file.path).toList();
  }

  @override
  PdfFileModel? getPdfById(String id) {
    var box = Hive.box(kPdfFilesBox);
    final data = box.get(id);
    if (data != null) {
      return PdfFileModel.fromMap(Map<String, dynamic>.from(data));
    }
    return null;
  }
}
