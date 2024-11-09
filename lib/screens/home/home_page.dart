import 'package:flutter/material.dart';
import '../booking/booking_today_page.dart';
import '../booking/divination_all_booking_page.dart';
import '../post/post_managerment_page.dart';
import '../tarotdeck/tarot_deck_managerment.dart';
import 'package:tarot/api/booking_api.dart'; 
import 'package:tarot/api/post_api.dart'; 
import 'package:tarot/api/card_api.dart'; 

class HomePage extends StatefulWidget {
  final String readerId; 

  HomePage({required this.readerId}); 

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final GetCountBookingTodayApi bookingTodayApi = GetCountBookingTodayApi();
  final TotalBookingApi totalBookingApi = TotalBookingApi();
  final GetCountPostApi getCountPostApi = GetCountPostApi();
  final GetCountGroupCardApi getCountGroupCardApi = GetCountGroupCardApi();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent, 
                  elevation: 0,
                  title: Text(
                    'Welcome back Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2, 2))
                      ],
                    ),
                  ),
                  centerTitle: true,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<int>>(
                    future: _fetchBookingCounts(widget.readerId), 
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final bookingCounts = snapshot.data!;
                        return GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          children: <Widget>[
                            _buildDashboardCard(bookingCounts[0].toString(), 'Divination session today', Colors.white, context),
                            _buildDashboardCard(bookingCounts[1].toString(), 'Divination session all', Colors.white.withOpacity(0.7), context),
                            _buildDashboardCard(bookingCounts[3].toString(), 'Card decks', Colors.white.withOpacity(0.7), context),
                            _buildDashboardCard(bookingCounts[2].toString(), 'Posts', Colors.white.withOpacity(0.7), context),
                          ],
                        );
                      }
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

  Future<List<int>> _fetchBookingCounts(String readerId) async {
    final todayCount = await bookingTodayApi.fetchBookingCount(readerId);
    final totalCount = await totalBookingApi.fetchTotalBookingCount(readerId);
    final totalPostCount = await getCountPostApi.fetchPostCount(readerId);
    final totalGroupCardCount = await getCountGroupCardApi.fetchCardCount(readerId);
    return [todayCount, totalCount, totalPostCount, totalGroupCardCount]; 
  }

  Widget _buildDashboardCard(String number, String label, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == 'Divination session today') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingTOdayPage(readerId: widget.readerId)));
        } else if (label == 'Divination session all') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DivinationAllPage(readerId: widget.readerId)));
        } else if (label == 'Card decks') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TarotDeckManagementPage(readerId: widget.readerId)));
        } else if (label == 'Posts') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostManagementPage(readerId: widget.readerId)));
        }
      },
      child: Card(
        color: color.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  number,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2, 2))]
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2, 2))]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
