import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore if needed
// Import your DatabaseHelper

class GirlpageWidget extends StatefulWidget {
  final String selectedNationality;

  const GirlpageWidget({super.key, required this.selectedNationality});

  @override
  _GirlpageWidgetState createState() => _GirlpageWidgetState();
}

class _GirlpageWidgetState extends State<GirlpageWidget> {
  late Future<List<Map<String, dynamic>>> _nameData;
  int _currentIndex = 0; // Initialize with a default value
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nameData =
        _loadNameDataFromCSV(); // Load data from CSV in Firebase Storage
    _loadInterstitialAd();
    _loadCurrentIndex();
  }

  Future<List<Map<String, dynamic>>> _loadNameDataFromCSV() async {
    try {
      String nationality = widget.selectedNationality;

      // Replace 'firestorebabynames.csv' with your actual CSV file path in Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('firestorebabynames.csv');

      // Download the CSV file as a byte buffer
      final data = await ref.getData();

      // Convert Uint8List to List<int>
      List<int> byteList = data!.toList();

      // Decode the byte buffer to a string and then parse CSV
      String csvData = utf8.decode(byteList); // Convert byte list to string
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvData);

      // Assuming CSV format is: name,meaning,nationality,gender
      List<Map<String, dynamic>> dataList = [];
      for (var row in csvTable) {
        if (row[3] == 'F' && row[2] == nationality) {
          // Check gender column for 'F'
          dataList.add({
            'name': row[0],
            'meaning': row[1],
            'nationality': row[2],
            'gender': row[3],
          });
        }
      }

      return dataList;
    } catch (e) {
      print('Error loading data from CSV: $e');
      return []; // Return empty list or handle error as needed
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Replace with your actual AdMob ad unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _loadInterstitialAd();
            },
          );
          setState(() {
            _isInterstitialAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _isInterstitialAdReady = false;
          });
        },
      ),
    );
  }

  Future<void> _loadCurrentIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('currentIndex') ?? 0;
    });
  }

  Future<void> _saveCurrentIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentIndex', index);
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd.show();
    }
  }

  void _navigateToNextName() {
    setState(() {
      _currentIndex++;
      _saveCurrentIndex(_currentIndex);
    });

    if ((_currentIndex + 1) % 10 == 0) {
      _showInterstitialAd(); // Show interstitial ad after every 10 names
    }
  }

  void _navigateToPreviousName() {
    setState(() {
      _currentIndex--;
      if (_currentIndex < 0) {
        _currentIndex = 0; // Ensure index doesn't go below 0
      }
      _saveCurrentIndex(_currentIndex);
    });

    if ((_currentIndex + 1) % 10 == 0) {
      _showInterstitialAd(); // Show interstitial ad after every 10 names
    }
  }

  Future<void> _saveLikedNameToFirestore(String name, String meaning) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? udid = prefs.getString('udid');

      if (udid != null) {
        String hashedUdid = _hashUdid(udid);
        print(
            'Checking if name exists in Firestore: $name for user: $hashedUdid');

        // Check if the name already exists
        QuerySnapshot existingNames = await _firestore
            .collection('users')
            .doc(hashedUdid)
            .collection('liked_names')
            .where('name', isEqualTo: name)
            .get();

        if (existingNames.docs.isEmpty) {
          // Name does not exist, save it to Firestore
          print('Saving liked name to Firestore: $name for user: $hashedUdid');
          await _firestore
              .collection('users')
              .doc(hashedUdid)
              .collection('liked_names')
              .add({
            'name': name,
            'meaning': meaning,
          });
          print('Saved liked name to Firestore successfully');
        } else {
          print('Name already exists in Firestore');
        }
      } else {
        print('Error: UDID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  Future<void> _saveRejectdNameToFirestore(String name, String meaning) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? udid = prefs.getString('udid');

      if (udid != null) {
        String hashedUdid = _hashUdid(udid);
        print(
            'Checking if name exists in Firestore: $name for user: $hashedUdid');

        // Check if the name already exists
        QuerySnapshot existingNames = await _firestore
            .collection('users')
            .doc(hashedUdid)
            .collection('rejected_names')
            .where('name', isEqualTo: name)
            .get();

        if (existingNames.docs.isEmpty) {
          // Name does not exist, save it to Firestore
          print(
              'Saving rejected name to Firestore: $name for user: $hashedUdid');
          await _firestore
              .collection('users')
              .doc(hashedUdid)
              .collection('rejected_names')
              .add({
            'name': name,
            'meaning': meaning,
          });
          print('Saved rejected name to Firestore successfully');
        } else {
          print('Name already exists in Firestore');
        }
      } else {
        print('Error: UDID not found in SharedPreferences');
      }
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  String _hashUdid(String udid) {
    var bytes = utf8.encode(udid); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _nameData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data!;
          final name = data[_currentIndex]['name'];
          final meaning = data[_currentIndex]['meaning'];

          return GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 0) {
                _navigateToPreviousName();
              } else if (details.primaryVelocity! < 0) {
                _navigateToNextName();
              }
            },
            child: Container(
              color: Colors.deepPurpleAccent,
              child: Column(
                children: [
                  const SizedBox(height: 70.0),
                  Image.asset('assets/image/babyexplore1.png'),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 350,
                    child: Card(
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: SizedBox(
                        width: 350,
                        height: 320,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    meaning,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      final data = await _nameData;
                                      final currentName = data[_currentIndex];
                                      //final int id = currentName['id'];
                                      final name = currentName['name'];
                                      final meaning = currentName['meaning'];
                                      //await DatabaseHelper().updateLikedName(id, 1);
                                      await _saveLikedNameToFirestore(
                                          name, meaning);
                                      setState(() {
                                        currentName['liked_name'] = 1;
                                      });
                                      _navigateToNextName();
                                    },
                                    child: Image.asset(
                                        'assets/image/likedname.png'),
                                  ),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: _navigateToNextName,
                                    child:
                                        Image.asset('assets/image/recycle.png'),
                                  ),
                                  const SizedBox(width: 50),
                                  GestureDetector(
                                    onTap: () async {
                                      final data = await _nameData;
                                      final currentName = data[_currentIndex];
                                      //final int id = currentName['id'];
                                      final name = currentName['name'];
                                      final meaning = currentName['meaning'];
                                      //await DatabaseHelper().updateLikedName(id, 1);
                                      await _saveRejectdNameToFirestore(
                                          name, meaning);
                                      setState(() {
                                        currentName['rejected_names'] = 1;
                                      });
                                      _navigateToNextName();
                                    },
                                    child: Image.asset(
                                        'assets/image/rejectedname.png'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: [
                        Transform.rotate(
                          angle: 380 * 3.1415927 / 189,
                          child: Image.asset(
                            'assets/image/baby-clothes.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    '<< Slide to unveil the lovely name >>',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }
}
