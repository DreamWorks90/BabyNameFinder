import 'package:babyname/Gender/genderselection.dart';
import 'package:flutter/material.dart';

import '../invitepage.dart';
import '../BottomNavigationBar/likednames.dart';
import '../BottomNavigationBar/matchesname.dart';
import '../nationality.dart';
import 'rejectednames.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
// Index of the current page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA724F1),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFA724F1),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        itemCount: 6, // Updated itemCount
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.white);
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: _getLeadingIcon(index),
            title: Text(
              _getTitleText(index),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              _handleListItemTap(context, index);
            },
          );
        },
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

  Icon _getLeadingIcon(int index) {
    switch (index) {
      // case 0:
      //   return const Icon(Icons.language, color: Colors.white);
      case 0:
        return const Icon(Icons.flag_outlined, color: Colors.white);
      case 1:
        return const Icon(Icons.female_sharp, color: Colors.white);
      case 2:
        return const Icon(Icons.add_link, color: Colors.white);
      case 3:
        return const Icon(Icons.thumb_down_alt_outlined, color: Colors.white);
      case 4: // New case for "About Child Name"
        return const Icon(Icons.favorite, color: Colors.white);
      default:
        return const Icon(Icons.info_outline, color: Colors.white);
    }
  }

  String _getTitleText(int index) {
    switch (index) {
      // case 0:
      //   return 'Language';
      case 0:
        return 'Nationality';
      case 1:
        return 'Change Gender';
      case 2:
        return 'Connect to Partner';
      case 3:
        return 'Rejected Names';
      case 4: // New case for "About Child Name"
        return 'Liked Names';
      default:
        return 'About Baby Name';
    }
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

  void _handleListItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NationalityPage()),
        );
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const GenderPage(
                    selectedNationality: '',
                  )),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvitePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const rejectednamepage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LikedNamePage()),
        );
        break;
    }
  }
}
