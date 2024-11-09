import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tarot/url/api_base_url.dart';
import 'package:tarot/model/card_model.dart';

class GetCountGroupCardApi {
  Future<int> fetchCardCount(String readerId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}GroupCardWeb/GetGroupCardsCountByReaderId/$readerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = response.body; 
      return int.parse(data); 
    } else {
      throw Exception('Failed to load Cards count');
    }
  }
}

class GetGroupCardApi {
  Future<CardListModel> fetchGroupCards({
    required String readerId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final url = Uri.parse(
      '${ApiBaseUrl.baseUrl}GroupCardWeb/GetGroupCardsWithImagesByReaderId/$readerId?pageNumber=$pageNumber&pageSize=$pageSize',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return CardListModel.fromJson(data);
    } else {
      throw Exception('Failed to load group cards');
    }
  }
}


class GetCardDataApi {
  Future<CardList> fetchCardsByGroup(String groupId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}CardWeb/cards-by-group/$groupId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return CardList.fromJson(data);
    } else {
      throw Exception('Failed to load cards data');
    }
  }
}