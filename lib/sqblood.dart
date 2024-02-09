import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BDonation dbBDonation = BDonation();
  final _nameController = TextEditingController();
  final _bloodcontroller = TextEditingController();
  final _agecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _phonecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  BDonation? bDonation;
  late int updateindex;

  late List<BDonor> bloodlist;

  List<BDonor>? get bl => null;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: Text("Flutter Sqflite Example"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    controller: _nameController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Name Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Blood group"),
                    controller: _bloodcontroller,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Blood group Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "E mail"),
                    controller:_emailcontroller ,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "E mail Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Age"),
                    controller: _agecontroller,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Age Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Phone number"),
                    controller: _phonecontroller,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Phone number Should not be Empty",
                  ),
                  ElevatedButton(

                    child: Container(
                        width: width * 0.9,
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                        )),
                    onPressed: () {
                      submitBDonor(context);
                    },
                  ),
                  FutureBuilder(
                    future: dbBDonation.getBDonorList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bloodlist = snapshot.data as List<BDonor>;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: bloodlist == null ? 0 : bloodlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            BDonor bl = bloodlist[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width: width * 0.50,
                                      child: Column(
                                        children: <Widget>[
                                          Text('ID: ${bl.id}'),
                                          Text('Name: ${bl.name}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _nameController.text = bl.name;
                                      _bloodcontroller.text = bl.bloodgroup;
                                      bloodlist = bl as List<BDonor>;
                                      updateindex = index;
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      dbBDonation.deleteBDonor(bl.id);
                                      setState(() {
                                        bloodlist.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void submitBDonor(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      if (bDonation == null) {
        BDonor bl =  BDonor(
            name: _nameController.text, bloodgroup:_bloodcontroller.text, phone: _phonecontroller.text, email:_emailcontroller.text, age: _agecontroller.text);
        dbBDonation.insertBDonor(bl).then((value) => {
          _nameController.clear(),
          _bloodcontroller.clear(),
          print("Donor Data Add to database $value"),
        });
      }
      else {
        bDonation?.name = _nameController.text;
        bDonation?.bloodgroup = _bloodcontroller.text;

        dbBDonation.updateBDonor(bloodlist! as BDonor).then((value) {
          setState(() {
            bloodlist[updateindex].name = _nameController.text;
            bloodlist[updateindex].bloodgroup = _bloodcontroller.text;
          });
          _nameController.clear();
          _bloodcontroller.clear();
           bloodlist = bl!;
        });
      }
    }
  }
}