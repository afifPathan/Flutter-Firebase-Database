import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_database/main.dart';

class AddDatapage extends StatefulWidget {
  @override
  _AddDatapageState createState() => _AddDatapageState();
}

class _AddDatapageState extends State<AddDatapage> {

  GlobalKey<FormState> _key = new GlobalKey();
  bool _autoValidate = false;
  String name, profession, message;
  List<DropdownMenuItem<String>> items = [
    new DropdownMenuItem(
      child: new Text('Student'),
      value: 'Student',
    ),
    new DropdownMenuItem(
      child: new Text('Professor'),
      value: 'Professor',
    ),
    new DropdownMenuItem(
      child: new Text('Developer'),
      value: 'Developer',
    ),
    new DropdownMenuItem(
      child: new Text('Other'),
      value: 'Other',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Data'),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidate: _autoValidate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                decoration: new InputDecoration(hintText: 'Name'),
                validator: validateName,
                onSaved: (val) {
                  name = val;
                },
                maxLength: 32,
              ),
            ),
            new SizedBox(width: 10.0),
            new DropdownButtonHideUnderline(
                child: new DropdownButton(
                  items: items,
                  hint: new Text('Profession'),
                  value: profession,
                  onChanged: (String val) {
                    setState(() {
                      profession = val;
                    });
                  },
                ))
          ],
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Message'),
          onSaved: (val) {
            message = val;
          },
          validator: validateMessage,
          maxLines: 5,
          maxLength: 256,
        ),
        new RaisedButton(
          onPressed: _sendToServer,
          child: new Text('Send'),
        ),
      ],
    );
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      var data = {
        "name": name,
        "profession": profession,
        "message": message,
      };
      ref.child('Table').push().set(data).then((v) {
        _key.currentState.reset();
      });

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => new ShowDataPage()));

    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateName(String val) {
    return val.length == 0 ? "Enter Name First" : null;
  }

  String validateMessage(String val) {
    return val.length == 0 ? "Enter Email First" : null;
  }

}
