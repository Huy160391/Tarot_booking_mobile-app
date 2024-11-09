import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarot/model/reader_model.dart';
import 'package:tarot/url/api_base_url.dart';

class ReaderApi {
  Future<ApiResponse?> fetchReader(String readerId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}ReaderWeb/reader-with-images/$readerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ApiResponse.fromJson(data); 
    } else {
      throw Exception('Failed to load reader data');
    }
  }
}

class PostUpdateProfile {
  final String apiUrl = "${ApiBaseUrl.baseUrl}ReaderWeb/update-reader";

  Future<bool> updateProfile(UpdateProfileModel model) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      request.fields['Id'] = model.id;
      request.fields['Name'] = model.name ?? ''; 
      request.fields['Phone'] = model.phone ?? '';
      request.fields['Description'] = model.description ?? '';
      request.fields['Dob'] = model.dob ?? '';
      

      
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Profile updated successfully.');
        return true;
      } else {
        print('Error: ${response.statusCode}, ${await response.stream.bytesToString()}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}