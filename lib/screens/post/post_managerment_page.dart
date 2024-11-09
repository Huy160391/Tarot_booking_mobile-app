import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tarot/api/post_api.dart'; 
import 'package:tarot/model/post_model.dart';
import '../post/post_detail_page.dart';

class PostManagementPage extends StatefulWidget {
  final String readerId; // Pass readerId from the HomePage

  PostManagementPage({required this.readerId});

  @override
  _PostManagementPageState createState() => _PostManagementPageState();
}

class _PostManagementPageState extends State<PostManagementPage> {
  List<Post> posts = []; // Change to a list of Post
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  int? editingIndex;

  final GetPostByReader postApi = GetPostByReader();

  @override
  void initState() {
    super.initState();
    fetchPosts(); 
  }

  Future<void> fetchPosts() async {
    PostResponse? response = await postApi.fetchPostsByReader(widget.readerId);
    if (response != null) {
      setState(() {
        posts = response.posts; 
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path); 
      });
    }
  }

  void savePost(String title, String content) {
   
  }

  void showPostDialog({Post? post, int? index}) {
    if (post != null) {
      titleController.text = post.post.title;
      contentController.text = post.post.text;
      selectedImage = null; 
      editingIndex = index;
    } else {
      titleController.clear();
      contentController.clear();
      selectedImage = null;
      editingIndex = null;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(post != null ? 'Edit Post' : 'Add New Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick Image'),
              ),
              if (selectedImage != null) ...[
                Image.file(
                  selectedImage!,
                  height: 100,
                  width: 100,
                ),
              ] else ...[
                Image.asset(
                  'assets/images/default_image.png',
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  savePost(titleController.text, contentController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(post != null ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void deletePost(int index) {
    setState(() {
      posts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Management'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: posts.isNotEmpty
                    ? ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostDetailPage(post: post),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              margin: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      post.post.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(post.post.text),
                                  ),
                                  _buildMedia(post.url ?? '', post.post.content),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No posts available. Add a new post!',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(String mediaPath, String content) {
    if (mediaPath.isNotEmpty) {
      if (mediaPath.contains('alt=media')) {
        return Image.network(
          mediaPath,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/default_image.png',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            );
          },
        );
      }
    }

    return Image.asset(
      'assets/images/default_image.png',
      fit: BoxFit.cover,
      height: 200,
      width: double.infinity,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
