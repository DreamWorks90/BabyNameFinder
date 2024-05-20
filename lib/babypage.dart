import 'package:babynames/invitepage.dart';
import 'package:flutter/material.dart';

class BabyPage extends StatefulWidget {
  const BabyPage({super.key});

  @override
  State<BabyPage> createState() => _BabyPageState();
}

class _BabyPageState extends State<BabyPage> {
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
