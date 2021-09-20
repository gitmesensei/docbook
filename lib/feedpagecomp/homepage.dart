import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/feedpagecomp/news/addnewnews.dart';
import 'package:docbook/feedpagecomp/posts/addnewposts.dart';
import 'package:docbook/feedpagecomp/news/news.dart';
import 'package:docbook/feedpagecomp/news/newsmainscreen.dart';
import 'package:flutter/material.dart';
import 'posts/post.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  FirebaseUser currentuser;

  @override
  void initState() {
    _loadCurrentUser();


    super.initState();
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
    return new WillPopScope(
      onWillPop: () async => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Container(
        child:ListView(
        padding: EdgeInsets.only(top: 0.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20,top: 10,),
            child: Row(
              children: <Widget>[
                Text("Trending",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 25.0,
                      letterSpacing: 1.0,
                    )),
                Icon(Icons.trending_up,size: 30,color: Colors.pinkAccent,),

              ],
            ),
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
                        MaterialPageRoute(builder: (context) => NewsShow()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.pinkAccent,
                    textColor: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
                      child: Text("check out more !",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text("Articles", style: TextStyle(color: Colors.lightBlue)),
              ],
            ),
          ),

          NewsSlideshow(),

          Padding(
            padding: EdgeInsets.only(top: 10,left: 20),
            child: Row(
              children: <Widget>[

                Text("Posts",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 25.0,
                      letterSpacing: 1.0,
                    )),

                Icon(Icons.language,size: 40,color: Colors.pinkAccent,),

              ],
            ),
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
                        MaterialPageRoute(builder: (context) => AddPost()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.pinkAccent,
                    textColor: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
                      child: Text("what's up doc ?",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(" Thoughts From The World", style: TextStyle(color: Colors.lightBlue)),
                SizedBox(
                  width: 25.0,
                ),
              ],
            ),
          ),
          Posts(),
        ],
      ),
    ));
  }
}
