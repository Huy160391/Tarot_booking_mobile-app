import 'package:tarot/api/auth_api.dart';


class AuthService {
  final AuthApi _authApi = AuthApi();

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final loginResponse = await _authApi.fetchAuthTokenWithEmailPassword(email, password);
      if (loginResponse != null && loginResponse.success) {
        return loginResponse.token; 
      }
      return null;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }
}
