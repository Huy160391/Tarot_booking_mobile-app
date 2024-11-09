import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarot/model/notification_model.dart';
import 'package:tarot/api/notification_api.dart';

class NotificationPage extends StatefulWidget {
  final String readerId;

  const NotificationPage({Key? key, required this.readerId}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() async {
    try {
      final notificationApi = NotificationApi();
      final fetchedNotifications = await notificationApi.fetchNotifications(widget.readerId);
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> markAsRead(int index) async {
    final notification = notifications[index];
    try {
      final notificationReadApi = NotificationReadApi();
      await notificationReadApi.markNotificationAsRead(notification.id);

      setState(() {
        notifications[index] = NotificationModel(
          id: notification.id,
          userId: notification.userId,
          readerId: notification.readerId,
          title: notification.title,
          isRead: true,
          description: notification.description,
          createAt: notification.createAt,
        );
      });
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/tarotpage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final formattedDate = DateFormat('hh:mm a, dd/MM/yyyy').format(notification.createAt);

                      return Card(
                        color: notification.isRead ? Colors.grey[400] : Colors.white,
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(notification.title ?? "No Title"),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            notification.description.length > 40
                                ? '${notification.description.substring(0, 40)}...'
                                : notification.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!notification.isRead)
                                Icon(Icons.notifications, color: Colors.red),
                              SizedBox(height: 4),
                              Text(formattedDate),
                            ],
                          ),
                          onTap: () async {
                            if (!notification.isRead) {
                              await markAsRead(index);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationDetailPage(notification: notification),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('hh:mm a, dd/MM/yyyy').format(notification.createAt);

    return Scaffold(
      body: Column(
        children: [
          Container(height: 50.0, color: Colors.black),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/tarotpage.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.title ?? "No Title", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Date: $formattedDate', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                      SizedBox(height: 20),
                      Text(notification.description, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
