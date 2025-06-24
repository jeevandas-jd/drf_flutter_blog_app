import 'package:flutter/material.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final green1 = const Color.fromARGB(255, 89, 238, 154);
    final green2 = const Color.fromARGB(255, 55, 219, 96);
    final green3 = const Color(0xFF06923E);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [green1, green2, green3],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🌟 Logo or Illustration (You can replace with an AssetImage)
            const Icon(
              Icons.article_rounded,
              color: Colors.white,
              size: 120,
            ),

            // 📝 App Title
            const Text(
              "Welcome to\nBlogVerse",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    offset: Offset(1, 2),
                  )
                ],
              ),
            ),

            // 🔘 Buttons
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.login),
                  label: const Text("Sign In"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: green3,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text("Create Account"),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
