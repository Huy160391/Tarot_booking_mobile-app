// auth_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarot/model/auth_model.dart';
import 'package:tarot/model/login_response_model.dart';
import 'package:tarot/url/api_base_url.dart';

class AuthApi {
  Future<LoginResponseModel?> fetchAuthTokenWithEmailPassword(
      String email, String password) async {
    final url = Uri.parse("${ApiBaseUrl.authUrl}login");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponseModel.fromJson(data);
      } else {
        print('Server error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
class ChangePasswordApi {
  Future<bool> changePassword(ChangePasswordModel model) async {
    final url = Uri.parse("${ApiBaseUrl.baseUrl}ReaderWeb/change-password");

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['ReaderId'] = model.readerId;
      request.fields['OldPassword'] = model.oldPassword;
      request.fields['NewPassword'] = model.newPassword;
      request.fields['ConfirmPassword'] = model.confirmPassword;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Password changed successfully.');
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

