import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Map? post;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPostDetail();
  }

  Future<void> fetchPostDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://localhost:8000/api/posts/${widget.postId}'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        post = json.decode(response.body);
        isLoading = false;
      });
    } else {
      print('Failed to load post detail');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFAF3),
      appBar: AppBar(
        title: const Text("Post Detail"),
        backgroundColor: const Color(0xFF06923E),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : post == null
              ? const Center(
                  child: Text(
                    "Post not found",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post!['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF06923E),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            post!['content'] ?? 'No content found here.',
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
