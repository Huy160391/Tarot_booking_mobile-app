import 'package:flutter/material.dart';
import 'package:tarot/api/card_api.dart';
import 'package:tarot/model/card_model.dart';
import 'package:tarot/screens/tarotdeck/card_page.dart'; 

class TarotDeckManagementPage extends StatefulWidget {
  final String readerId;

  TarotDeckManagementPage({required this.readerId});

  @override
  _TarotDeckManagementPageState createState() =>
      _TarotDeckManagementPageState();
}

class _TarotDeckManagementPageState extends State<TarotDeckManagementPage> {
  List<CardModel> tarotDecks = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  int currentPage = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchDecks();
  }

  Future<void> fetchDecks({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        isFetchingMore = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final fetchedDecks = await GetGroupCardApi().fetchGroupCards(
        readerId: widget.readerId,
        pageNumber: currentPage,
        pageSize: pageSize,
      );

      setState(() {
        if (isLoadMore) {
          tarotDecks.addAll(fetchedDecks.cards);
        } else {
          tarotDecks = fetchedDecks.cards;
        }
        isFetchingMore = false;
        isLoading = false;
        currentPage++;
      });
    } catch (e) {
      print('Failed to load decks: $e');
      setState(() {
        isFetchingMore = false;
        isLoading = false;
      });
    }
  }

  Widget _buildDeckView(CardModel deck) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardPage(groupId: deck.id),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            deck.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            child: deck.url != null
                ? Image.network(
                    deck.url!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, color: Colors.grey),
                  )
                : Icon(Icons.broken_image, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarot Deck Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              currentPage = 1;
              tarotDecks.clear();
              fetchDecks();
            },
          ),
        ],
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
          isLoading
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: tarotDecks.length + (isFetchingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == tarotDecks.length) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var deck = tarotDecks[index];
                    return Card(
                      color: Colors.white.withOpacity(0.8),
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(deck.name),
                          ),
                          _buildDeckView(deck),
                        ],
                      ),
                    );
                  },
                  controller: ScrollController()
                    ..addListener(() {
                      if (!isFetchingMore &&
                          !isLoading &&
                          ScrollController().position.pixels ==
                              ScrollController().position.maxScrollExtent) {
                        fetchDecks(isLoadMore: true);
                      }
                    }),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
