// notification_model.dart
class NotificationModel {
  final String id;
  final String? userId;
  final String? readerId;
  final String? title;
  final bool isRead;
  final String description;
  final DateTime createAt;

  NotificationModel({
    required this.id,
    this.userId,
    this.readerId,
    this.title,
    required this.isRead,
    required this.description,
    required this.createAt,
  });

  // Factory constructor to create an instance from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      readerId: json['readerId'] as String?,
      title: json['title'] as String?,
      isRead: json['isRead'] as bool,
      description: json['description'] as String,
      createAt: DateTime.parse(json['createAt'] as String),
    );
  }
}
