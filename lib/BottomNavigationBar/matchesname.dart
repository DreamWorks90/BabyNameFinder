import 'package:babynames/Gender/genderselection.dart';
import 'package:flutter/material.dart';

import 'likednames.dart';
import '../settings/settings.dart';

class matchesnamepage extends StatefulWidget {
  const matchesnamepage({super.key});

  @override
  _matchesnamepage createState() => _matchesnamepage();

  _matchesnamepagestate() {}
}

class _matchesnamepage extends State<matchesnamepage> {
  int _currentIndex = 2;
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
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
          MaterialPageRoute(builder: (context) => const GenderPage(selectedNationality: '',)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const likednamepage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const matchesnamepage()),
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
