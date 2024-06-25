import 'package:babyname/invitepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BabyPage extends StatefulWidget {
  const BabyPage({super.key});

  @override
  State<BabyPage> createState() => _BabyPageState();
}

class _BabyPageState extends State<BabyPage> {
  @override
  void initState() {
    super.initState();
    _storeLatestUdid(); // Store the latest UDID when the page is initialized
  }

  Future<void> _storeLatestUdid() async {
    // Get the hashed UDID and store it in Firestore
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? hashedUdid = prefs.getString('hashed_udid');
    if (hashedUdid != null) {
      await _updateLatestActiveSession(hashedUdid);
    }
  }

  Future<void> _updateLatestActiveSession(String hashedUdid) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(hashedUdid);

    // Update the latest active session timestamp
    await userDoc.set({
      'latest_active_session': Timestamp.now(),
    }, SetOptions(merge: true));

    print('Updated latest active session for hashed UDID: $hashedUdid');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFA724F1),
          centerTitle: true,
          elevation: 0, // Remove elevation
        ),
        backgroundColor: const Color(0xFFA724F1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image below app bar
            Image.asset(
              'assets/image/babynames.png', // Change the path accordingly
              width: 150, // Adjust the width as needed
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1st image in center
                    Positioned(
                      child: Image.asset(
                        'assets/image/babybg.png', // Change the path accordingly
                        width: 4000, // Adjust the width as needed
                        height: 4000, // Adjust the height as needed
                        fit: BoxFit.contain,
                      ),
                    ),
                    // GIF overlaid on top of the image
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the second page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InvitePage()),
                          );
                        },
                        child: Image.asset(
                          'assets/image/baby.gif', // Change the path accordingly
                          width: 250, // Adjust the width as needed
                          height: 250, // Adjust the height as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Text at the bottom
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Tap the Baby ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
