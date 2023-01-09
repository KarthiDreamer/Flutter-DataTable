import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: HomePage(),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //map to store the json data
  late Map<String, dynamic> map;

  //function to load the json data in a map
  void loadData() async {
    print("loading...");
    var data = await rootBundle.loadString("tablevalue.json");
    setState(() {
      print("setstate");
      map = json.decode(data);
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Create DataColumn List from the map
    List<DataColumn> myColumns = [
      for (var column in map["data"][0].keys) DataColumn(label: Text(column))
    ];

    //Create DataRow List from the map
    List<DataRow> Rows = [];
    List<DataCell> Cells = [];

    for (var row in map["data"]) {
      row.keys.forEach((key) => {Cells.add(DataCell(Text(row[key])))});
      Rows.add(DataRow(cells: Cells));
      Cells = [];
    }

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: myColumns,
            rows: Rows,
            sortColumnIndex: 1,
            sortAscending: true,
          ),
        ),
      ),
    );
  }
}
