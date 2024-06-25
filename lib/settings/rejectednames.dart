import 'package:babyname/BottomNavigationBar/matchesname.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../Gender/genderselection.dart';
import '../db/database_helper.dart';
import '../settings/settings.dart';

class rejectednamepage extends StatefulWidget {
  const rejectednamepage({super.key});

  @override
  _rejectednamepageState createState() => _rejectednamepageState();
}

class _rejectednamepageState extends State<rejectednamepage> {
  final int _currentIndex = 1; // Index of the current page
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rejected Names',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set font weight to bold
          ),
        ),
        backgroundColor:
        Colors.blue, // Setting app bar background color to blue
        iconTheme:
        const IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      backgroundColor: Colors.blue, // Setting background color to blue
      body: Container(
        color: Colors.blue, // Setting background color to blue
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find the list of Rejected names', // Text in white color
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0), // Added space
            Expanded(
              child: FutureBuilder<String>(
                future: _getHashedUdid(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final String hashedUdid = snapshot.data!;
                    return StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .doc(hashedUdid)
                          .collection('rejected_names')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          final likedNames = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: likedNames.length,
                            itemBuilder: (context, index) {
                              final nameData = likedNames[index];
                              final name = nameData['name'];
                              final meaning = nameData['meaning'];

                              return GestureDetector(
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(meaning),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        _removeLikedName(hashedUdid, nameData.id, name);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
    );
  }

  Future<String> _getHashedUdid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? udid = prefs.getString('udid');
    if (udid != null) {
      return _hashUdid(udid);
    } else {
      throw Exception('UDID not found');
    }
  }

  String _hashUdid(String udid) {
    var bytes = utf8.encode(udid); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _updateLikedNameAndRemoveItem(int id) async {
    await DatabaseHelper().updateLikedName(id, 0);
    setState(() {
      // Refresh UI by rebuilding the widget tree
    });
  }

  void _removeLikedName(String hashedUdid, String documentId, String name) async {
    try {
      // Remove from Firestore
      await _firestore
          .collection('users')
          .doc(hashedUdid)
          .collection('rejected_names')
          .doc(documentId)
          .delete();

      // Find the local database ID for the name
      final localId = await DatabaseHelper().getIdByName(name);
      if (localId != null) {
        // Update the local database
        _updateLikedNameAndRemoveItem(localId);
      }
    } catch (e) {
      print('Error removing liked name: $e');
    }
  }


  Future<void> _addLikedName(String hashedUdid, String name, String meaning) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .doc(hashedUdid)
        .collection('rejected_names')
        .where('name', isEqualTo: name)
        .where('meaning', isEqualTo: meaning)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isEmpty) {
      await _firestore
          .collection('users')
          .doc(hashedUdid)
          .collection('rejected_names')
          .add({'name': name, 'meaning': meaning});
    } else {
      print('Name and meaning already exist.');
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
      // Do nothing as we are already on the liked names page
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
