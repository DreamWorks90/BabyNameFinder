import 'package:babynames/BottomNavigationBar/likednames.dart';
import 'package:babynames/rejectednamedetails.dart';
import 'package:flutter/material.dart';
import 'package:babynames/db/database_helper.dart';
import '../../db/database_helper.dart';
import 'package:babynames/Gender/genderselection.dart';
import 'package:babynames/likednamedetails.dart';
import 'package:babynames/settings/settings.dart';

class rejectednamepage extends StatefulWidget {
  const rejectednamepage({Key? key}) : super(key: key);

  @override
  _rejectednamepageState createState() => _rejectednamepageState();
}

class _rejectednamepageState extends State<rejectednamepage> {
  int _currentIndex = 3; // Index of the current page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rejected Names',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set font weight to bold
          ),
        ),
        backgroundColor: Colors.blue, // Setting app bar background color to blue
        iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      backgroundColor: Colors.blue, // Setting app bar background color to blue
      body: Container(
        color: Colors.blue, // Setting background color to blue
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find the list of Rejected names', // Text in white color
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0), // Added space
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper().getDataByRejectedName('1'),
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
                    final List<Map<String, dynamic>> rejectedNames = snapshot.data!;
                    return ListView.builder(
                      itemCount: rejectedNames.length,
                      itemBuilder: (context, index) {
                        final id = rejectedNames[index]['id'];
                        final name = rejectedNames[index]['name'];
                        final meaning = rejectedNames[index]['meaning'];

                        return GestureDetector(
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => RejectnamedetailsWidget(
                          //         name: name,
                          //         meaning: meaning,
                          //       ),
                          //     ),
                          //   );
                          // },
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
                                  //color: Colors.red,
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Updated background color
        selectedItemColor: Colors.grey, // Updated selected item color
        unselectedItemColor: Colors.black, // Added unselected item color
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            _navigateToPage(index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_alt_outlined),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _updateLikedNameAndRemoveItem(int id) async {
    await DatabaseHelper().updateRejectedName(id, 0);
    setState(() {
      // Refresh UI by rebuilding the widget tree
    });
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const likednamepage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GenderPage(selectedNationality: '',)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }
}
