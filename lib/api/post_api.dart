import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tarot/url/api_base_url.dart';
import 'package:tarot/model/post_model.dart';

class GetCountPostApi {

  Future<int> fetchPostCount(String readerId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}PostWeb/CountReaderPosts?readerId=$readerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = response.body; 
      return int.parse(data); 
    } else {
      throw Exception('Failed to load Post count');
    }
  }
}

class GetPostByReader {
  Future<PostResponse?> fetchPostsByReader(String readerId, {int pageNumber = 1, int pageSize = 10}) async {
    final String url = '${ApiBaseUrl.baseUrl}PostWeb/paged-posts-by-reader?readerId=$readerId&pageNumber=$pageNumber&pageSize=$pageSize';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PostResponse.fromJson(data);
      } else {
        print('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return null;
  }
}