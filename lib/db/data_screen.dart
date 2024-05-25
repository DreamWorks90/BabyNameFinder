import 'package:babyname/db/database_helper.dart';
import 'package:flutter/material.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = getData();
  }

  Future<List<Map<String, dynamic>>> getData() async {
    return dbHelper.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Meanings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dataFuture,
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
            List<Map<String, dynamic>> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['name']),
                  subtitle: Text(
                      'Meaning: ${data[index]['meaning']}\nNationality: ${data[index]['nationality']}\nGender: ${data[index]['gender']}'),
                  trailing: IconButton(
                    icon: Icon(
                      data[index]['liked_name'] == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: data[index]['liked_name'] == 1
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      // Toggle liked status
                      int liked = data[index]['liked_name'] == 1 ? 0 : 1;
                      dbHelper.updateLikedName(data[index]['id'], liked);
                      setState(() {
                        data[index]['liked_name'] = liked;
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
