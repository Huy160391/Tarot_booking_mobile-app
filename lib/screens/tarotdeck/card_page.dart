import 'package:flutter/material.dart';
import 'package:tarot/api/card_api.dart';
import 'package:tarot/model/card_model.dart';
import 'package:tarot/screens/tarotdeck/card_detail.dart';

class CardPage extends StatefulWidget {
  final String groupId;

  CardPage({required this.groupId});

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  List<CardData> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  Future<void> fetchCards() async {
    try {
      final fetchedCards =
          await GetCardDataApi().fetchCardsByGroup(widget.groupId);

      setState(() {
        cards = fetchedCards.cards;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load cards: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards in Group'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  'Total Cards: ${cards.length}', 
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          var card = cards[index];
                          return Card(
                            margin: EdgeInsets.all(10),
                            color: Colors.white.withOpacity(0.8), 
                            child: ListTile(
                              title: Text(card.name),
                              subtitle: Text(card.message),
                              leading: card.imageUrl.isNotEmpty
                                  ? Image.network(
                                      card.imageUrl,
                                      width: 120,  
                                      height: 120, 
                                    )
                                  : Icon(Icons.broken_image, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CardDetailPage(card: card),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
