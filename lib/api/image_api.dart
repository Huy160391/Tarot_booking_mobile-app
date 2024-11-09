
import 'package:http/http.dart' as http;
import 'package:tarot/url/api_base_url.dart';
import 'package:tarot/model/image_model.dart';

class PostUpdateReaderImage {
  Future<void> updateImage(UpdateImageRequest request) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}Images/UpdateImage');

    try {
      final multipartRequest = http.MultipartRequest('POST', url)
        ..fields['ReaderId'] = request.readerId
        ..files.add(await http.MultipartFile.fromPath('File', request.imageFile.path));

      final response = await multipartRequest.send();
      if (response.statusCode == 200) {
        print("Image updated successfully");
      } else {
        print("Failed to update image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}