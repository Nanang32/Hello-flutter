import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper class
import 'dest.dart'; // Import the Dest class

void main() async {
  // Initialize the database and insert dests
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeDests();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Dest Management', home: DestList());
  }
}

class DestList extends StatefulWidget {
  const DestList({super.key});

  @override
  _DestListState createState() => _DestListState();
}

class _DestListState extends State<DestList> {
  List<Dest> _dests = [];

  @override
  void initState() {
    super.initState();
    _fetchDests();
  }

  Future<void> _fetchDests() async {
    final destMaps = await DatabaseHelper.instance.queryAllDests();
    setState(() {
      _dests = destMaps.map((destMap) => Dest.fromMap(destMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GFG Dest List'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: _dests.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_dests[index].title));
        },
      ),
    );
  }
}
