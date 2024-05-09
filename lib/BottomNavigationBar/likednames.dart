import 'package:flutter/material.dart';
import 'package:babynames/db/database_helper.dart';
import 'package:babynames/BottomNavigationBar/gender.dart';
import 'package:babynames/settings/settings.dart';
import 'package:babynames/BottomNavigationBar/matchesname.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class likednamepage extends StatefulWidget {
  const likednamepage({Key? key}) : super(key: key);

  @override
  _likednamepageState createState() => _likednamepageState();
}

class _likednamepageState extends State<likednamepage> {
  int _currentIndex = 1; // Index of the current page
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liked Names',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set font weight to bold
          ),
        ),
        backgroundColor:
            Colors.blue, // Setting app bar background color to blue
        iconTheme:
            IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      backgroundColor: Colors.blue, // Setting app bar background color to blue
      body: Container(
        color: Colors.blue, // Setting background color to blue
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find the list of liked names', // Text in white color
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0), // Added space
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getDataByLikedName('1'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final List<Map<String, dynamic>> likedNames =
                        snapshot.data!;
                    return ListView.builder(
                      itemCount: likedNames.length,
                      itemBuilder: (context, index) {
                        final id = likedNames[index]['id'];
                        final name = likedNames[index]['name'];
                        final meaning = likedNames[index]['meaning'];

                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            child: ListTile(
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(meaning),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _updateLikedNameAndRemoveItem(id);
                                },
                              ),
                            ),
                          ),
                        );
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
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
            SizedBox(height: 10), // Added space
            if (_isBannerAdLoaded)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: AdWidget(ad: _bannerAd),
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                  ),
                  IconButton(
                    onPressed: () {
                      _bannerAd.dispose();
                      setState(() {
                        _isBannerAdLoaded = false;
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _updateLikedNameAndRemoveItem(int id) async {
    await DatabaseHelper().updateLikedName(id, 0);
    setState(() {
      // Refresh UI by rebuilding the widget tree
    });
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GenderPage()),
        );
        break;
      case 1:
        // Do nothing as we are already on the liked names page
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
