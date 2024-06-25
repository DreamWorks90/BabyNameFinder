import 'package:babyname/Gender/genderselection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NationalityPage extends StatefulWidget {
  const NationalityPage({super.key});

  @override
  State<NationalityPage> createState() => _NationalityPageState();
}

class _NationalityPageState extends State<NationalityPage> {
  String? _selectedNationality;
  late SharedPreferences _prefs;
  late bool _showNationalityPage;

  final List<String> _nationalities = [
    'China',
    'India',
    'Italy',
  ];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _showNationalityPage = _prefs.getBool('showNationalityPage') ?? true;
      _selectedNationality = _prefs.getString('selectedNationality');
    });
  }

  Future<void> _saveSelectedNationality(String nationality) async {
    await _prefs.setString('selectedNationality', nationality);
  }

  @override
  Widget build(BuildContext context) {
    if (!_showNationalityPage) {
      return const GenderPage(selectedNationality: '');
    }
    return Scaffold(
      backgroundColor: const Color(0xFFA724F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA724F1),
        title: const Text(
          'Nationality',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Choose Nationality to discover the ideal name for your bundle of joy together.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                _showNationalityModal(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedNationality ?? 'Select Nationality',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedNationality != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedNationality != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GenderPage(
                                selectedNationality:
                                    _selectedNationality ?? '')),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please select a nationality.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 50),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next Page',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNationalityModal(BuildContext context) async {
    final String? selectedNationality = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return _NationalitySearch(
          nationalities: _nationalities,
        );
      },
    );

    if (selectedNationality != null) {
      setState(() {
        _selectedNationality = selectedNationality;
        _prefs.setBool('showNationalityPage', false);
        _prefs.setString('selectedNationality',
            selectedNationality); // Save selected nationality
      });
    }
  }
}

class _NationalitySearch extends StatefulWidget {
  final List<String> nationalities;
  const _NationalitySearch({required this.nationalities});

  @override
  __NationalitySearchState createState() => __NationalitySearchState();
}

class __NationalitySearchState extends State<_NationalitySearch> {
  late List<String> _filteredNationalities;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredNationalities = widget.nationalities;
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredNationalities = widget.nationalities
          .where((nationality) => nationality
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search Nationality',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredNationalities.length,
            itemBuilder: (BuildContext context, int index) {
              final nationality = _filteredNationalities[index];
              return ListTile(
                title: Text(nationality),
                onTap: () {
                  Navigator.pop(context, nationality);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
