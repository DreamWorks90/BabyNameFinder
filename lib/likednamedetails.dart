import 'package:flutter/material.dart';
import 'package:babynames/BottomNavigationBar/likednames.dart';
import 'package:babynames/db/database_helper.dart';

class BabyNameDetailsWidget extends StatefulWidget {
  final String meaning;
  final String name;

  const BabyNameDetailsWidget({Key? key,  this.meaning='', required this.name}) : super(key: key);

  @override
  _BabyNameDetailsWidgetState createState() => _BabyNameDetailsWidgetState();
}

class _BabyNameDetailsWidgetState extends State<BabyNameDetailsWidget> {
  late Future<List<Map<String, dynamic>>> _nameData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _nameData = DatabaseHelper().getData();
  }

  void _navigateToNextName() async {
    final data = await _nameData;
    setState(() {
      _currentIndex++;
      // Wrap around to the beginning if reached the end
      if (_currentIndex >= data.length) {
        _currentIndex = 0;
      }
      // Iterate until a name with liked_name = 1 is found or reached the end of the list
      while (_currentIndex < data.length && data[_currentIndex]['liked_name'] != 1) {
        _currentIndex++;
        if (_currentIndex >= data.length) {
          _currentIndex = 0; // Wrap around to the beginning if reached the end
        }
      }
    });
  }

  void _navigateToPreviousName() async {
    final data = await _nameData;
    setState(() {
      _currentIndex--;
      // Wrap around to the end if reached the beginning
      if (_currentIndex < 0) {
        _currentIndex = data.length - 1;
      }
      // Iterate until a name with liked_name = 1 is found or reached the beginning of the list
      while (_currentIndex >= 0 && data[_currentIndex]['liked_name'] != 1) {
        _currentIndex--;
        if (_currentIndex < 0) {
          _currentIndex = data.length - 1; // Wrap around to the end if reached the beginning
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(


      future: _nameData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final data = snapshot.data!;
          final name = widget.name;
          final meaning = widget.meaning;

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                _navigateToPreviousName();
              } else if (details.delta.dx < 0) {
                _navigateToNextName();
              }
            },
            child: Container(
              color: Colors.deepPurpleAccent, // Set background color to violet
              child: Column(
                children: [
                  const SizedBox(height: 60.0),
                  Image.asset('assets/image/babyexplore.png'),
                  const SizedBox(height: 30.0),
                  Container(
                    width: 350, // Set the width of the container
                    child: Card(
                      color: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            const SizedBox(height: 10.0),
                            Text(
                              'Name Meaning',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              meaning,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // GestureDetector(
                                //   onTap: () async {
                                //     final data = await _nameData;
                                //     final currentName = data[_currentIndex];
                                //     final int id = currentName['id'];
                                //     await DatabaseHelper().updateLikedName(id, 1);
                                //     // Update UI to reflect the change if needed
                                //     setState(() {
                                //       currentName['liked_name'] = 1;
                                //     });
                                //   },
                                //   child: Image.asset('assets/image/rejectedname.png'),
                                // ),
                                //SizedBox(width: 50), // Added for spacing
                                GestureDetector(
                                  //onTap: _navigateToNextName,
                                  child: Image.asset('assets/image/likedname.png'),
                                ),
                                //SizedBox(width: 50), // Added for spacing

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: [
                        Transform.rotate(
                          angle: 380 * 3.1415927 / 189, // Rotating image by 90 degrees
                          child: Image.asset(
                            'assets/image/baby-clothes.png', // Image Widget
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0), // Removed the SizedBox and added direct spacing
                  Text(
                    '<< Liked Name >>',
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
}