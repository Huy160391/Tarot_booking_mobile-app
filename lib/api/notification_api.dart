// notification_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:tarot/model/notification_model.dart';
import 'package:tarot/url/api_base_url.dart';

class NotificationApi {
  Future<List<NotificationModel>> fetchNotifications(String readerId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}NotificationWeb/get-reader-noti?readerId=$readerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
class NotificationReadApi {
    Future<bool> markNotificationAsRead(String notificationId) async {
    final url = Uri.parse("${ApiBaseUrl.baseUrl}NotificationWeb/mark-as-read?notificationId=$notificationId");
    final response = await http.post(url);

    if (response.statusCode == 200) {
      return true;  
    } else {
      throw Exception('Failed to mark notification as read');
    }
  }
}
