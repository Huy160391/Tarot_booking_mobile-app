import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home/home_page.dart';
import 'screens/login/login_page.dart';
import 'screens/profile/setting_page.dart';
import 'screens/profile/profile_page.dart';
import 'screens/booking/booking_page.dart';
import 'screens/notification/notification_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarot Booking App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: LoginPage(),
      supportedLocales: [
        const Locale('vi', ''), 
        const Locale('en', ''), 
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('vi', ''),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String readerId;

  HomeScreen({required this.readerId}); 
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages; 

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomePage(readerId: widget.readerId), 
      BookingPage(readerId: widget.readerId),
      ProfilePage(readerId: widget.readerId), 
      NotificationPage(readerId: widget.readerId),
      SettingProfilePage(readerId: widget.readerId), 
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Tarot Booking App'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Booking'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color.fromARGB(255, 249, 152, 33),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}

