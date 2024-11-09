class PostModel {
  final String id;
  final String? userId;
  final String readerId;
  final String title;
  final String text;
  final String content;
  final DateTime createAt;
  final String status;

  PostModel({
    required this.id,
    this.userId,
    required this.readerId,
    required this.title,
    required this.text,
    required this.content,
    required this.createAt,
    required this.status,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      readerId: json['readerId'],
      title: json['title'],
      text: json['text'],
      content: json['content'],
      createAt: DateTime.parse(json['createAt']),
      status: json['status'],
    );
  }
}

class PostResponse {
  final int totalItems;
  final int totalPages;
  final List<Post> posts;

  PostResponse({
    required this.totalItems,
    required this.totalPages,
    required this.posts,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      posts: (json['posts'] as List)
          .map((item) => Post.fromJson(item))
          .toList(),
    );
  }
}

class Post {
  final PostModel post; 
  final String? url;

  Post({
    required this.post,
    this.url,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      post: PostModel.fromJson(json['post']), 
      url: json['url'],
    );
  }
}
