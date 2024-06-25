import "package:babyname/BottomNavigationBar/likednames.dart";
import "package:babyname/BottomNavigationBar/matchesname.dart";
import "package:babyname/Gender/boypage.dart";
import "package:babyname/Gender/girlpage.dart";
import "package:babyname/Gender/notsure.dart";
import "package:babyname/settings/settings.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class GenderPage extends StatefulWidget {
  final String selectedNationality;

  const GenderPage({super.key, required this.selectedNationality});

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  late String _selectedNationality; // Declare selectedNationality variable

  final int _currentIndex = 0; // Index of the current page
  @override
  void initState() {
    super.initState();
    _loadSelectedNationality(); // Load selected nationality from shared preferences
  }

  Future<void> _loadSelectedNationality() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedNationality = prefs.getString('selectedNationality') ??
          ''; // Retrieve selected nationality
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA724F1),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
            'assets/image/babynames.png'), // Adjust path accordingly
      ),
      backgroundColor: const Color(0xFFA724F1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 80,
                    right: 80,
                  ),
                  child: Image.asset('assets/image/gendertext.png'),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 300,
                    right: 40,
                  ),
                  child: Image.asset('assets/image/duck.png'),
                ),

                const SizedBox(height: 10), // Adjust spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                              'assets/image/toy.png'), // Adjust path accordingly
                          // Add labels if needed
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BoypageWidget(
                                      selectedNationality:
                                          _selectedNationality),
                                ),
                              );
                            },
                            icon: Image.asset(
                                'assets/image/boy.png'), // Adjust path accordingly
                          ),
                          // Add labels if needed
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30), // Adjust spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Column(
                        children: [],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GirlpageWidget(
                                      selectedNationality:
                                          _selectedNationality),
                                ),
                              );
                            },
                            icon: Image.asset(
                                'assets/image/girl.png'), // Adjust path accordingly
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                              'assets/image/train.png'), // Adjust path accordingly
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Adjust spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                              'assets/image/feeder.png'), // Adjust path accordingly
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotsurepageWidget(
                                      selectedNationality:
                                          _selectedNationality),
                                ),
                              );
                            },
                            icon: Image.asset(
                                'assets/image/notsure.png'), // Adjust path accordingly
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 120,
                        right: 40,
                      ),
                      child: Image.asset('assets/image/bell.png'),
                    ),
                  ],
                ),
              ],
            ),
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
