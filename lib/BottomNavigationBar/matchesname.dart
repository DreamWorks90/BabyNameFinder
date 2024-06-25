import 'package:babyname/Gender/genderselection.dart';
import 'package:flutter/material.dart';

import 'likednames.dart';
import '../settings/settings.dart';

class MatchesNamePage extends StatefulWidget {
  const MatchesNamePage({super.key});

  @override
  _MatchesNamePageState createState() => _MatchesNamePageState();
}

class _MatchesNamePageState extends State<MatchesNamePage> {
  final List<String> likedNames = [
    "Emma",
    "Liam",
    "Olivia",
    "Noah",
    "Ava",
    "William",
    "Isabella",
    "James",
    "Sophia",
    "Benjamin"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA724F1),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display "Liked Names" text
            Text(
              'matched Names:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            // Display liked names
          ],
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  _navigateToPage(0);
                },
                icon: Image.asset(
                  'assets/image/home.png',
                  width: 40,
                  height: 40,
                ),
              ),
              IconButton(
                onPressed: () {
                  _navigateToPage(1);
                },
                icon: Image.asset(
                  'assets/image/likes.png',
                  width: 40,
                  height: 40,
                ),
              ),
              IconButton(
                onPressed: () {
                  _navigateToPage(2);
                },
                icon: Image.asset(
                  'assets/image/matches.png',
                  width: 48,
                  height: 48,
                ),
              ),
              IconButton(
                onPressed: () {
                  _navigateToPage(3);
                },
                icon: Image.asset(
                  'assets/image/settings.png',
                  width: 44,
                  height: 44,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const GenderPage(
                    selectedNationality: '',
                  )),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LikedNamePage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MatchesNamePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }
}
