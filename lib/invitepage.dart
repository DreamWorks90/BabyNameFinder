import 'package:babyname/nationality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA724F1),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFA724F1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/image/babynames.png', // Change the path accordingly
            width: 150, // Adjust the width as needed
          ),
          const SizedBox(
            width: 100,
          ),
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 150),
            child: Image.asset('assets/image/invitepage.png'),
          ),
          GestureDetector(
            onTap: () {
              // Show share dialog when the button is tapped
              _showShareDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'assets/image/invitebutton.png',
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NationalityPage()),
                );
              },
              child: const Text(
                "Not now ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ))
        ],
      ),
    );
  }

  void _showShareDialog() async {
    try {
      await FlutterShare.share(
        title: 'Share via', // Title of the share sheet
        text: 'Your invitation message here', // Invitation message
      );
    } catch (e) {}
  }
}
