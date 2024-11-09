import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tarot/url/api_base_url.dart';
import 'package:tarot/model/booking_model.dart';
class GetCountBookingTodayApi {
  Future<int> fetchBookingCount(String readerId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}BookingWeb/booking-count-today?readerId=$readerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = response.body; 
      return int.parse(data); 
    } else {
      throw Exception('Failed to load booking count');
    }
  }
}
class TotalBookingApi {
  Future<int> fetchTotalBookingCount(String readerId) async {
    final url = Uri.parse('${ApiBaseUrl.baseUrl}BookingWeb/total-booking-count?readerId=$readerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = response.body; 
      return int.parse(data); 
    } else {
      throw Exception('Failed to load total booking count');
    }
  }
}

class AllBookingApi {
  Future<BookingModel> fetchPagedBookings({
    required String readerId,
    int pageNumber = 1, 
    int pageSize = 10,  
    String? searchTerm,
    List<int>? statuses,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final baseUrl = '${ApiBaseUrl.baseUrl}BookingWeb/paged-bookings';

    Map<String, dynamic> queryParams = {
      'readerId': readerId,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      if (searchTerm != null) 'searchTerm': searchTerm,
      if (statuses != null) ...statuses.asMap().map((i, status) => MapEntry('statuses', status.toString())),
      if (startDate != null) 'startDate': startDate.toIso8601String(),
      if (endDate != null) 'endDate': endDate.toIso8601String(),
    };

    final url = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return BookingModel.fromJson(data);
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}
