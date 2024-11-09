class ApiResponse {
  final Reader? reader;
  final List<String>? url;

  ApiResponse({this.reader, this.url});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      reader: json['reader'] != null ? Reader.fromJson(json['reader']) : null,
      url: (json['url'] as List?)?.map((e) => e as String).toList(),
    );
  }
}

class Reader {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? username;
  final double? rating;
  final double? price;
  final String? description;
  final DateTime? dob;
  final List<Booking>? bookings;
  final List<Comment>? comments;
  final List<ImageData>? images;
  final List<Notification>? notifications;
 
  Reader({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.username,
    this.rating,
    this.price,
    this.description,
    this.dob,
    this.bookings,
    this.comments,
    this.images,
    this.notifications,
    
  });

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      bookings: (json['bookings'] as List?)?.map((i) => Booking.fromJson(i)).toList(),
      comments: (json['comments'] as List?)?.map((i) => Comment.fromJson(i)).toList(),
      images: (json['images'] as List?)?.map((i) => ImageData.fromJson(i)).toList(),
      notifications: (json['notifications'] as List?)?.map((i) => Notification.fromJson(i)).toList(),
      
    );
  }
}

class Booking {
  final String? id;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final double? total;
  final int? rating;

  Booking({
    this.id,
    this.timeStart,
    this.timeEnd,
    this.total,
    this.rating,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String?,
      timeStart: json['timeStart'] != null ? DateTime.parse(json['timeStart']) : null,
      timeEnd: json['timeEnd'] != null ? DateTime.parse(json['timeEnd']) : null,
      total: (json['total'] as num?)?.toDouble(),
      rating: json['rating'] as int?,
    );
  }
}

class Comment {
  final String? id;
  final String? text;
  final DateTime? createAt;

  Comment({
    this.id,
    this.text,
    this.createAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String?,
      text: json['text'] as String?,
      createAt: json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
    );
  }
}

class ImageData {
  final String? url;

  ImageData({this.url});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'] as String?,
    );
  }
}

class Notification {
  final String? title;
  final bool? isRead;
  final String? description;

  Notification({
    this.title,
    this.isRead,
    this.description,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'] as String?,
      isRead: json['isRead'] as bool?,
      description: json['description'] as String?,
    );
  }
}




class UpdateProfileModel {
  String id;
  String? name; 
  String? phone;
  String? description;
  String? dob; 
  

  UpdateProfileModel({
    required this.id,
    this.name,
    this.phone,
    this.description,
    this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'description': description,
      'dob': dob,
    };
  }
}
