import 'package:flutter/material.dart';
import 'package:tarot/api/reader_api.dart';
import 'package:tarot/model/reader_model.dart';
import 'package:tarot/api/booking_api.dart';
import '../post/post_grid.dart';

class ProfilePage extends StatefulWidget {
  final String readerId;

  const ProfilePage({required this.readerId, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ApiResponse?> _readerFuture;
  final TotalBookingApi totalBookingApi = TotalBookingApi();
  int? _bookingCount;

  @override
  void initState() {
    super.initState();
    _readerFuture = ReaderApi().fetchReader(widget.readerId);
    _fetchBookingCounts();
  }

  Future<void> _fetchBookingCounts() async {
    final totalCount = await totalBookingApi.fetchTotalBookingCount(widget.readerId);
    setState(() {
      _bookingCount = totalCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder<ApiResponse?>(
          future: _readerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print("Error: ${snapshot.error}");
              return _buildError("Error loading profile");
            } else if (!snapshot.hasData || snapshot.data!.reader == null) {
              print("Profile not found");
              return _buildError("Profile not found");
            }

            final apiResponse = snapshot.data!;
            final reader = apiResponse.reader;
            print("Fetched Data from API: $reader");
            return _buildProfile(reader, apiResponse);
          },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(child: Text(message, style: TextStyle(color: Colors.red)));
  }

  Widget _buildProfile(Reader? reader, ApiResponse apiResponse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildProfileHeader(reader, apiResponse),
        SizedBox(height: 5),
        _buildProfileDescription(reader),
        SizedBox(height: 20),
        _buildStats(reader),
        SizedBox(height: 20),
        PostGrid(readerId: widget.readerId),
      ],
    );
  }

  Widget _buildProfileHeader(Reader? reader, ApiResponse apiResponse) {
    final String profileImageUrl = (apiResponse.url?.isNotEmpty == true)
        ? apiResponse.url!.first
        : 'https://via.placeholder.com/150';

    return Stack(
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/tarotpage.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              SizedBox(height: 10),
              Text(
                reader?.name ?? 'No Name Available',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDescription(Reader? reader) {
    return Text(
      reader?.description ?? 'No Description Available',
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontStyle: FontStyle.italic,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStats(Reader? reader) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Rating', (reader?.rating != null ? (reader!.rating! + 0.05).toStringAsFixed(1) : '0.0')),
        _buildStatItem('Price', '${(reader?.price != null ? (reader!.price! + 0.05).toStringAsFixed(1) : '0.0')}VND'),
        _buildStatItem('Bookings', _bookingCount?.toString() ?? '0'),
      ],
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
