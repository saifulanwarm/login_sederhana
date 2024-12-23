import 'package:flutter/material.dart';
import 'package:flutter_front/service/auth.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Map<String, dynamic>> data = [];
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await fetchProtectedData();
      setState(() {
        // Mapping the response data into the data list
        data = [
          {
            'id': response['data']['id'],
            'name': response['data']['name'],
            'email': response['data']['email'],
            'created_at': response['data']['created_at'],
          }
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text('Error: $errorMessage'),
                )
              : data.isEmpty
                  ? const Center(
                      child: Text('No data available.'),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Card(
                          child: ListTile(
                            leading: Text('ID: ${item['id']}'),
                            title: Text('Name: ${item['name']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${item['email']}'),
                                Text('Created At: ${item['created_at']}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
