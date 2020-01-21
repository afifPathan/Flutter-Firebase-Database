import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase_database/AddDataPage.dart';
import 'package:flutter_firebase_database/myData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFF167F67),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Firebase Database',
      home: ShowDataPage(),
    );
  }
}

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  List<myData> allData = [];

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Table').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        myData d = new myData(
          data[key]['name'],
          data[key]['message'],
          data[key]['profession'],
        );
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Firebase Data'),
      ),
      body: new Container(
          color: Colors.white,
          child: allData.length == 0
              ? new Text(' No Data is Available')
              : new ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) {
                    return cardData(
                      allData[index].name,
                      allData[index].profession,
                      allData[index].message,
                    );
                  },
                )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new AddDatapage()));
        },
      ),
    );
  }

  Widget cardData(String name, String profession, String message) {
    return new Card(
      elevation: 10.0,
      child: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              'Name : $name',
              style: Theme.of(context).textTheme.title,
            ),
            new Text('Profession : $profession'),
            new Text('Message : $message'),
          ],
        ),
      ),
    );
  }
}


/*
actions: <Widget>[
IconSlideAction(
caption: 'More',
color: Colors.green,
icon: Icons.edit,
onTap: () => () {},
),
],
secondaryActions: <Widget>[
IconSlideAction(
caption: 'Delete',
color: Colors.red,
icon: Icons.delete,
onTap: () => () {},
),
]*/
