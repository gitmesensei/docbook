import 'package:docbook/friendsandrequest/profilepage.dart';
import 'package:docbook/friendsandrequest/profilepagerequest.dart';
import 'package:docbook/friendsandrequest/searchfriendrequest.dart';
import 'package:docbook/friendsandrequest/searchfriends.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPage createState() => new _FirstPage();
}

class _FirstPage extends State<FirstPage> {

  FirebaseUser currentuser;
  String userid;
  bool isCurrentUser;


  @override
  void initState() {
    super.initState();

      _loadCurrentUser();


  }

  void _loadCurrentUser()  {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser =  user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
        child: ListView(
                      padding: EdgeInsets.only(top: 0.0),
                      primary: true,
                      children: <Widget>[
                        Row(
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child:
                              Text("Friend Requests",
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 25.0,
                                    letterSpacing: 1.0,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: 10,
                                    height: 10,
                                    child: RaisedButton(
                                      onPressed: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SearchFriendsReq())
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0)),
                                      color: Colors.pinkAccent,
                                      textColor: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0, vertical: 6.0),
                                        child: Text("see all",
                                            style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                ]
                              ),
                            ),


                          ],
                        ),

                        Padding(
                          child:friendrequest(),
                          padding: EdgeInsets.all(5.0),
                        ),

                        SizedBox(
                          height: 15.0,
                        ),

                        Row(
                          children: <Widget>[

                            Padding(
                              child: Text("Friends",
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 25.0,
                                    letterSpacing: 1.0,
                                  )),
                              padding: EdgeInsets.only(left: 10.0,top: 10.0),

                            ),


                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: <Widget>[
                                  ButtonTheme(
                                    minWidth: 10,
                                    height: 10,
                                    child: RaisedButton(
                                      onPressed: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => SearchFriends())
                                        );

                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0)),
                                      color: Colors.pinkAccent,
                                      textColor: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0, vertical: 6.0),
                                        child: Text("see all",
                                            style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),


                        Padding(
                          child:friends(),
                          padding: EdgeInsets.all(5.0),
                        ),
                      ],
        )
    );
  }
  Widget _users(userid) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 10.0, top: 10.0),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(userid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading....');
            DocumentSnapshot user = snapshot.data;
            return InkWell(
              onTap: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(userid))
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                            image:user['image']!=''? NetworkImage(user['image']):AssetImage('assets/heart.gif',),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 2.0,
                            color: Colors.lightBlue,
                            style: BorderStyle.solid),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1.0,
                              color: Colors.black12,
                              spreadRadius: 4.0)
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      user['name'].toString().toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
  Widget _usersR(userid) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 10.0, top: 10.0),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(userid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading....');
            DocumentSnapshot user = snapshot.data;
            return InkWell(
              onTap: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePageRequest(userid))
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                            image:user['image']!=''? NetworkImage(user['image']):AssetImage('assets/heart.gif',),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 2.0,
                            color: Colors.lightBlue,
                            style: BorderStyle.solid),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1.0,
                              color: Colors.black12,
                              spreadRadius: 4.0)
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      user['name'].toString().toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }


  // ignore: missing_return
  Widget friendrequest(){

    try{
      String id = currentuser.uid.toString();

    return StreamBuilder(
        stream: Firestore.instance.collection('Users').where('request_sent',arrayContains:id )
            .limit(3).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text('loading....'),
            );
          }else if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator()
            );
          } if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context,index){
                  userid = snapshot.data.documents[index].documentID;
                  return new AnimatedContainer(
                    duration: Duration(seconds: 2),
                    child:Column(
                      children: <Widget>[
                        _usersR(userid),/////top user profile image and name
                      ],

                    ),

                  );
                }


            );
          }
          return Center(
            child: Text('loading..'),
          );

        });
    }catch ( Exception ){

    }
  }
  // ignore: missing_return
  Widget friends() {
    try {
      String id2 = currentuser.uid.toString();
      return StreamBuilder(
          stream: Firestore.instance.collection('Users')
              .where('friends', arrayContains: id2).limit(5).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('loading....'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator()
              );
            }else if(snapshot.data.documents.isEmpty) {
              return Padding(
                  padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                  child:Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10
                          )
                        ],
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Center(
                      child:  Text(' you do not have any friends yet ',style: TextStyle(color: Colors.white),),
                    ),
                  )
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    userid = snapshot.data.documents[index].documentID;

                    return  userid!=currentuser.uid.toString()?Container(
                      child: Column(
                        children: <Widget>[
                          _users(userid), /////top user profile image and name
                        ],

                      ),

                    ):SizedBox(width: 0.1,height: 0,);
                  }


              );
            }
            return Center(
              child: Text('loading..'),
            );
          });
    }catch(Exception){

    }
    }
}
