import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'currentuserposts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile.dart';

class FourthPage extends StatefulWidget {
  @override
  _FourthState createState() => _FourthState();
}

class _FourthState extends State<FourthPage> {
  FirebaseUser currentuser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
         // color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: <Widget>[
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('Users')
                      .document(currentuser.uid.toString())
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snap) {
                    if (!snap.hasData)
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    DocumentSnapshot profile = snap.data;
                    String username =
                        profile['username'].toString().toLowerCase();
                    String status = profile['status'].toString().toLowerCase();
                    String bio = profile['bio'].toString().toLowerCase();

                    return new Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            height: 210,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.lightBlue),
                            child: Image.asset(
                              'assets/image_02.jpg',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0, right: 10),
                          alignment: Alignment.topRight,
                          child: ButtonTheme(
                            minWidth: 5,
                            height: 5,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              color: Colors.pinkAccent,
                              textColor: Colors.white,
                              child: Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      Text("profile",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 160),
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.lightBlueAccent,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1.0,
                                      color: Colors.black12,
                                      spreadRadius: 2.0)
                                ],
                                border: Border.all(
                                    width: 2.0,
                                    color: Colors.white,
                                    style: BorderStyle.solid)),
                            child: Padding(
                                padding:
                                    EdgeInsets.only(top: 0, left: 5, right: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                            profile['name']
                                                .toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 5, right: 5, top: 5),
                                        child: Text('@$username',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Center(
                            child: Container(
                          margin: EdgeInsets.only(top: 50),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                width: 2.0,
                                color: Colors.white,
                                style: BorderStyle.solid),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1.0,
                                  color: Colors.black12,
                                  spreadRadius: 4.0)
                            ],
                            image: DecorationImage(
                              image: profile['image'] != ''
                                  ? NetworkImage(profile['image'])
                                  : AssetImage(
                                      'assets/heart.gif',
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                        Column(
                          children: <Widget>[
                            profile['status'] != ''
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 268, left: 5, right: 5),
                                      child: Text('$status',
                                          style: TextStyle(
                                              color: Colors.lightBlue)),
                                    ),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            profile['bio'] != ''
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20, left: 10, right: 10),
                                      child: Text(
                                        '$bio',
                                        style: TextStyle(
                                          color: Colors.lightBlue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            profile['profession'] != ''
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 20, left: 10, right: 10),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Profession:  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.pinkAccent)),
                                              TextSpan(
                                                  text: profile['profession'],
                                                  style: TextStyle(
                                                    color: Colors.lightBlue,
                                                  ))
                                            ],
                                          ),
                                        )),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            profile['workat'] != ''
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Work At:  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.pinkAccent)),
                                              TextSpan(
                                                  text: profile['workat'],
                                                  style: TextStyle(
                                                    color: Colors.lightBlue,
                                                  ))
                                            ],
                                          ),
                                        )),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            profile['college'] != ''
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'college:  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.pinkAccent)),
                                              TextSpan(
                                                  text: profile['college'],
                                                  style: TextStyle(
                                                    color: Colors.lightBlue,
                                                  ))
                                            ],
                                          ),
                                        )),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            profile['dob'] != ''
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'DOB:  ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Colors.pinkAccent)),
                                              TextSpan(
                                                  text: profile['dob'],
                                                  style: TextStyle(
                                                    color: Colors.lightBlue,
                                                  ))
                                            ],
                                          ),
                                        )),
                                  )
                                : SizedBox(
                                    height: 0.1,
                                  ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: CurrentUserPosts(),
                            )
                          ],
                        )
                      ],
                    );
                  }),
            ],
          ));
    } catch (Exception) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
