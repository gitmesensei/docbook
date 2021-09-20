import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../main.dart';

class ChooseUsername extends StatefulWidget {
  @override
  _ChooseUsernameState createState() => _ChooseUsernameState();
}

class _LoginData {
  String username = '';
  String name = '';
}

class _ChooseUsernameState extends State<ChooseUsername> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  int check;

  String _validateUsername(String value) {
    doesNameAlreadyExist(value);
    if (value.length < 5) {
      return 'The Username must be at least 5 characters.';
    } else if(check!=0){
      print('najnj:$check');
      return 'The Username already exist';

    }

    return null;
  }
  String _validateName(String value) {
    if (value.length < 5) {
      return 'The Name must be at least 5 characters.';
    }

    return null;
  }

  void doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Users')
        .where('username', isEqualTo: name.toString().toUpperCase())
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    print(documents.length);
    setState(() {
      this.check=documents.length;
    });
  }


  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      FirebaseAuth.instance.currentUser().then((user) {
        Firestore.instance
            .collection('Users')
            .document(user.uid.toString())
            .setData({
          'email': user.email,
          'user_id': user.uid.toString(),
          'username': this._data.username.toUpperCase(),
          'name': this._data.name,
          'image': '',
          'online': '',
          'college': '',
          'profession': '',
          'private':false,
          'workat': '',
          'friends':FieldValue.arrayUnion([user.uid.toString()]),
          'request_sent':FieldValue.arrayUnion([]),
          'dob': '',
          'bio': '',
          'status':'',
          'tag': '',
        }).whenComplete(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        });
      }).catchError((e) {
        return e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
        child: SafeArea(
            child: Scaffold(
      body: Center(
          child:ListView(
            children: <Widget>[

              Center(child:Container(
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 120),
                child: Text('DocBook',style: TextStyle(color: Colors.lightBlue,fontSize: 38,fontWeight: FontWeight.w400,letterSpacing:1,shadows: [
                  Shadow(color: Colors.black45,blurRadius: 2,)
                ]),),
              ),
              ),
              Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.lightBlue,
                      border: Border.all(
                          width: 2.0,
                          color: Colors.white,
                          style: BorderStyle.solid),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.black12,
                            spreadRadius: 4.0)
                      ]),
                  child: ImageIcon(
                    new AssetImage('assets/logo.png'),
                    color: Colors.white,
                    size: 50.2,
                  ),
              ),

              Container(
                padding: new EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                child: Form(
                  key: this._formKey,
                  child: Column(
                    children: <Widget>[
                      new TextFormField(
                          decoration: new InputDecoration(
                              hintText: 'username', labelText: 'Enter your username'),
                          validator: this._validateUsername,
                          onSaved: (String value) {
                            this._data.username = value;
                          }),
                      new TextFormField(
                          decoration: new InputDecoration(
                              hintText: 'name', labelText: 'Enter your name'),
                          validator: this._validateName,
                          onSaved: (String value) {
                            this._data.name = value;
                          }),
                      new Container(
                        width: screenSize.width,
                        child: new RaisedButton(
                          child: new Text(
                            'register',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: this.submit,
                          color: Colors.blue,
                        ),
                        margin: new EdgeInsets.only(top: 20.0),
                      ),
                    ],
                  ),
                ),
              )

          ],
          )
      ),
    )));
  }
}
