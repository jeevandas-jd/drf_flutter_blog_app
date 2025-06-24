import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://localhost:8000/api/posts/'), // change localhost if needed
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print("Failed to load posts: ${response.body}");
      setState(() => isLoading = false);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06923E),
        foregroundColor: Colors.white,
        title: Text('Blog Posts', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
              ? const Center(child: Text("No posts yet."))
              : ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(Icons.article, color: Colors.green),
                        ),
                        title: Text(
                          post['title'],
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          post['summary'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailScreen(
                                postId: post['id'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("New Post"),
        backgroundColor: const Color(0xFF06923E),
      ),
    );
  }
}
