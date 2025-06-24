import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'post_list_screen.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  bool isLoading = false;
  String? error;

  Future<void> createPost() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/posts/create/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: jsonEncode({
        'title': _title.text,
        'content': _content.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PostListScreen()),
      );
    } else {
      setState(() {
        error = "Failed to create post";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF06923E); // consistent green
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Post"),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _title,
                decoration: InputDecoration(
                  hintText: "Enter your post title",
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Content",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _content,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Write your blog post content...",
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: green),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: createPost,
                    icon: const Icon(Icons.send),
                    label: const Text(
                      "Publish",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
