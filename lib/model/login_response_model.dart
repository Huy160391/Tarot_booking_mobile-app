// login_response_model.dart
class LoginResponseModel {
  final bool success;
  final String token;

  LoginResponseModel({required this.success, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      token: json['token'] as String,
    );
  }
}
