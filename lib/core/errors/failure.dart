abstract class Failure {
  final String message;
  Failure(this.message);
}

class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure(super.message);
}

class FileSystemFailure extends Failure {
  FileSystemFailure(super.message);
}

class PdfGenerationFailure extends Failure {
  PdfGenerationFailure(super.message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(super.message);
}

class EmptyImagesFailure extends Failure {
  EmptyImagesFailure() : super('Please add at least one image.');
}

class ImageNotFoundFailure extends Failure {
  ImageNotFoundFailure() : super('Some images could not be found.');
}

class PdfNotFoundFailure extends Failure {
  PdfNotFoundFailure() : super('PDF file not found.');
}

class InvalidPdfFailure extends Failure {
  InvalidPdfFailure() : super('This PDF is corrupted.');
}

class PdfOpenFailure extends Failure {
  PdfOpenFailure() : super('Cannot open this PDF.');
}

class ShareFailure extends Failure {
  ShareFailure() : super('Failed to share the PDF. Please try again.');
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
