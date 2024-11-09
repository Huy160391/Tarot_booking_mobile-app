class ChangePasswordModel {
  final String readerId;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordModel({
    required this.readerId,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, String> toMap() {
    return {
      'ReaderId': readerId,
      'OldPassword': oldPassword,
      'NewPassword': newPassword,
      'ConfirmPassword': confirmPassword,
    };
  }
}
