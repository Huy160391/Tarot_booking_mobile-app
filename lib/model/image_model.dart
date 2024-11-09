import 'dart:io';

class UpdateImageRequest {
  final String readerId;
  final File imageFile;

  UpdateImageRequest({
    required this.readerId,
    required this.imageFile,
  });
}
