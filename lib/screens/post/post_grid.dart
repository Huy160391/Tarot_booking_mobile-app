import 'package:flutter/material.dart';
import 'package:tarot/api/post_api.dart';
import 'package:tarot/model/post_model.dart';
import '../post/post_detail_page.dart';

class PostGrid extends StatefulWidget {
  final String readerId;

  PostGrid({required this.readerId});

  @override
  _PostGridState createState() => _PostGridState();
}

class _PostGridState extends State<PostGrid> {
  late Future<PostResponse?> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = GetPostByReader().fetchPostsByReader(widget.readerId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostResponse?>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading posts"));
        } else if (!snapshot.hasData || snapshot.data!.posts.isEmpty) {
          return Center(child: Text("No posts available"));
        }

        final posts = snapshot.data!.posts;
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostDetailPage(post: post),
                  ),
                );
              },
              child: _buildGridPost(post.url),
            );
          },
        );
      },
    );
  }

  Widget _buildGridPost(String? imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default_image.png',
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'assets/images/default_image.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
