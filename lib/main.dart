import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'flutter demo',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BDonor bDonor=BDonor(phone: 'phone', name: 'name', email: 'email', age: 'age', bloodgroup: 'bloodgroup',);
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

    );
  }
}
class BDonor {
  int? id;
  late String name, age, bloodgroup, phone, email;

  BDonor(
      {this.id, required this.phone, required this.name, required this.email, required this.age, required this.bloodgroup});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'phone': phone,
      'email': email,
      'age': age,
      'bloodgroup': bloodgroup
    };
  }
}
class BDonation {
  late Database _database;

  set bloodgroup(String bloodgroup) {}

  set name(String name) {}

  Future openDB() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "bldonor.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE BloodDonor(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,age TEXT,phone TEXT,email TEXT,bloodgroup TEXT)");
    });
  }
  Future<int>insertBDonor(BDonor bDonor)async{
    await openDB();
    return await _database.insert('BDonor',bDonor.toMap());
  }
  Future<int>updateBDonor(BDonor bDonor)async{
    await openDB();
    return await _database.update('bDonor',bDonor.toMap(),where:'id=?',whereArgs:[bDonor.id]);
  }
  Future<void>deleteBDonor(int?id)async{
    await openDB();
    await _database.delete('bDonor',where:'id=?',whereArgs:[id]);
  }
  Future<List<BDonor>>getBDonorList()async{
    await openDB();
    final List<Map<String,dynamic>>maps=await _database.query('bDonor');
    return List.generate(maps.length, (index){
      return BDonor(phone: maps[index]['phone'], name: maps[index]['name'], email:maps[index]['email'], age: maps[index]['age'], bloodgroup: maps[index]['bloodgroup']);
    });
  }

  openDatabase(join, {required int version, required Future<Null> Function(Database db, int version) onCreate}) {}

  getDatabasesPath() {}

  join(param0, String s) {}
}

class Database {
  execute(String s) {}

  insert(String s, Map<String, dynamic> map) {}

  update(String s, Map<String, dynamic> map, {required String where, required List<int?> whereArgs}) {}

  delete(String s, {required String where, required List<int?> whereArgs}) {}

  query(String s) {}
}