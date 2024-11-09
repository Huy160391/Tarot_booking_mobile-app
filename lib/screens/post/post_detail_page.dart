import 'package:flutter/material.dart';
import 'package:tarot/model/post_model.dart';
import 'package:flutter_html/flutter_html.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  PostDetailPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.post.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            post.url != null
                ? Image.network(
                    post.url!,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/default_image.png');
                    },
                  )
                : Image.asset('assets/images/default_image.png'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.post.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Html(
                    data: post.post.text, 
                    style: {
                      'body': Style(
                        fontSize: FontSize(16.0),
                        color: Colors.black54,
                      ),
                    },
                  ),
                  SizedBox(height: 20),
                  Html(
                    data: post.post.content, 
                    style: {
                      'body': Style(
                        fontSize: FontSize(18),
                        color: Colors.black54,
                      ),
                    },
                  ),
                  
                  SizedBox(height: 10),
                  Text(
                    "Posted on ${post.post.createAt.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
