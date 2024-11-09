import 'package:flutter/material.dart';
import '../login/login_page.dart'; 
import 'edit_profile_page.dart'; 
import '../login/change_password_page.dart'; 
import 'package:tarot/model/reader_model.dart';
import 'package:tarot/api/reader_api.dart';

class SettingProfilePage extends StatefulWidget {
  final String readerId;

  SettingProfilePage({required this.readerId}); // Constructor to receive the readerId

  @override
  _SettingProfilePageState createState() => _SettingProfilePageState();
}

class _SettingProfilePageState extends State<SettingProfilePage> {
  late Future<ApiResponse?> _apiResponseFuture;

  @override
  void initState() {
    super.initState();
    _apiResponseFuture = _fetchReader(widget.readerId);
  }

  Future<ApiResponse?> _fetchReader(String readerId) async {
    final response = await ReaderApi().fetchReader(readerId);
    return response; // Trả về ApiResponse
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content with a bit of transparency
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    'Profile Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<ApiResponse?>(
                    future: _apiResponseFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error loading reader data"));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text("Reader not found"));
                      }

                      final apiResponse = snapshot.data!;
                      final reader = apiResponse.reader;

                      // Lấy URL hình ảnh từ apiResponse
                      final String profileImageUrl = 
                          (apiResponse.url?.isNotEmpty == true) 
                              ? apiResponse.url!.first 
                              : 'https://via.placeholder.com/150';

                      return Column(
                        children: <Widget>[
                          // Profile picture and name
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            backgroundImage: NetworkImage(profileImageUrl),
                          ),
                          SizedBox(height: 10),
                          Text(
                            reader?.name ?? 'No Name Available',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          // Settings Options
                          _buildProfileOption('Edit your profile', Icons.edit, context),
                          _buildProfileOption('Change password', Icons.lock, context),
                          SizedBox(height: 30),
                          _buildProfileOption('Log out', Icons.logout, context, isLogout: true),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String label, IconData icon, BuildContext context, {bool isLogout = false}) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {
          if (isLogout) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          } else if (label == 'Edit your profile') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePage(readerId: widget.readerId)), 
            );
          } else if (label == 'Change password') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePasswordPage(readerId: widget.readerId)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DummyPage(label: label)),
            );
          }
        },
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String label;

  DummyPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
        child: Text('This is the $label page'),
      ),
    );
  }
}
