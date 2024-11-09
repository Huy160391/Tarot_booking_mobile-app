import 'dart:convert';

class CardModel {
  final String id;
  final String name;
  final bool? isPublic;
  final DateTime createAt;
  final String? status;
  final String? url;

  CardModel({
    required this.id,
    required this.name,
    this.isPublic,
    required this.createAt,
    this.status,
    this.url,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      name: json['name'],
      isPublic: json['isPublic'],
      createAt: DateTime.parse(json['createAt']),
      status: json['status'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isPublic': isPublic,
      'createAt': createAt.toIso8601String(),
      'status': status,
      'url': url,
    };
  }
}

class CardListModel {
  final List<CardModel> cards;

  CardListModel({required this.cards});

  factory CardListModel.fromJson(List<dynamic> jsonList) {
    List<CardModel> cardItems = jsonList.map((json) => CardModel.fromJson(json)).toList();
    return CardListModel(cards: cardItems);
  }

  List<Map<String, dynamic>> toJson() {
    return cards.map((card) => card.toJson()).toList();
  }
}

CardListModel parseCardListModel(String jsonStr) {
  List<dynamic> jsonList = json.decode(jsonStr);
  return CardListModel.fromJson(jsonList);
}




class CardData {
  final String id;
  final String groupId;
  final String element;
  final String name;
  final String message;
  final DateTime createAt;
  final String status;
  final String imageUrl;

  CardData({
    required this.id,
    required this.groupId,
    required this.element,
    required this.name,
    required this.message,
    required this.createAt,
    required this.status,
    required this.imageUrl,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      element: json['element'] as String,
      name: json['name'] as String,
      message: json['message'] as String,
      createAt: DateTime.parse(json['createAt'] as String),
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'element': element,
      'name': name,
      'message': message,
      'createAt': createAt.toIso8601String(),
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}

class CardList {
  final List<CardData> cards;

  CardList({required this.cards});

  factory CardList.fromJson(List<dynamic> json) {
    return CardList(
      cards: json.map((item) => CardData.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return cards.map((card) => card.toJson()).toList();
  }
}
