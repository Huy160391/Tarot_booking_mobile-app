class BookingModel {
  final int totalRecords;
  final List<BookingItem> bookings;

  BookingModel({required this.totalRecords, required this.bookings});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    var bookingList = (json['bookings'] as List)
        .map((e) => BookingItem.fromJson(e))
        .toList();
    return BookingModel(
      totalRecords: json['totalRecords'],
      bookings: bookingList,
    );
  }
}

class BookingItem {
  final String userName;
  final BookingDetails booking;

  BookingItem({required this.userName, required this.booking});

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      userName: json['userName'],
      booking: BookingDetails.fromJson(json['booking']),
    );
  }
}

class BookingDetails {
  final String id;
  final String userId;
  final String readerId;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final DateTime createAt;
  final double? total;
  final int? rating;
  final String? feedback;
  final int status;
  final String? note;

  BookingDetails({
    required this.id,
    required this.userId,
    required this.readerId,
    this.timeStart,
    this.timeEnd,
    required this.createAt,
    this.total,
    this.rating,
    this.feedback,
    required this.status,
    this.note,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      id: json['id'],
      userId: json['userId'],
      readerId: json['readerId'],
      timeStart: json['timeStart'] != null ? DateTime.parse(json['timeStart']) : null,
      timeEnd: json['timeEnd'] != null ? DateTime.parse(json['timeEnd']) : null,
      createAt: DateTime.parse(json['createAt']),
      total: json['total']?.toDouble(),
      rating: json['rating'],
      feedback: json['feedback'],
      status: json['status'],
      note: json['note'],
    );
  }
}
