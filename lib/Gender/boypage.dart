import 'package:flutter/material.dart';
import 'package:babynames/db/database_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoypageWidget extends StatefulWidget {
  final String selectedNationality;

  const BoypageWidget({Key? key, required this.selectedNationality}) : super(key: key);

  @override
  _BoypageWidgetState createState() => _BoypageWidgetState();
}

class _BoypageWidgetState extends State<BoypageWidget> {
  late Future<List<Map<String, dynamic>>> _nameData;
  int _currentIndex = 0;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _nameData = DatabaseHelper().getDataByGenderAndNationality('M', widget.selectedNationality);
    _loadInterstitialAd();
    _loadCurrentIndex();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
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
    } else {
      print('Interstitial ad is not ready yet.');
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
                              // const SizedBox(
                              //   height: 48, // Set fixed height for the meaning
                              //   child: Text(
                              //     'Name Meaning',
                              //     style: TextStyle(
                              //       fontSize: 16.0,
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.bold,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 10.0),
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
                                      final int id = currentName['id'];
                                      await DatabaseHelper()
                                          .updateLikedName(id, 1);
                                      // Update UI to reflect the change if needed
                                      setState(() {
                                        currentName['liked_name'] = 1;
                                      });
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
                                      final int id = currentName['id'];
                                      await DatabaseHelper()
                                          .updateRejectedName(id, 1);
                                      // Update UI to reflect the change if needed
                                      setState(() {
                                        currentName['rejected_name'] = 1;
                                      });
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
                    '<< Slide to unveil the  lovely name >>',
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
