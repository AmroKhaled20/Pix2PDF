class PdfFileEntity {
  final String id;
  final String name;
  final int numOfPages;
  final String? thumbnailPath;
  final String size;
  final DateTime createdAt;
  final String pdfPath;
  final List<String> imagePaths;

  PdfFileEntity({
    required this.id,
    required this.name,
    required this.numOfPages,
    required this.thumbnailPath,
    required this.size,
    required this.createdAt,
    required this.pdfPath,
    required this.imagePaths,
  });
}
