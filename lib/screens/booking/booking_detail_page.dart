import 'package:flutter/material.dart';

class BookingDetailPage extends StatelessWidget {
  final String slot;
  final String deck;
  final String topic;

  BookingDetailPage({required this.slot, required this.deck, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with back button and title
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to previous page
          },
        ),
        title: Text(
          'Booking Detail',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true, // Center the title
      ),
      
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20), // Extra spacing after AppBar
                Card(
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Slot: $slot', style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),
                        Text('Customer name: Lê Văn Luyện'),
                        Text('Age: 32'),
                        Text('Topic: $topic'),
                        Text('Card deck: $deck'),
                        Text('Offer: 10\$'),
                        Text('Phone: 0335xxxx00'),
                        Text('Status: Paid'),
                        SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Action for 'Done' button
                            },
                            child: Text('Done'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
