import 'package:docbook/feedpagecomp/news/addnewnews.dart';
import 'package:docbook/webview.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/painting.dart';

class NewsShow extends StatefulWidget {
  @override
  _showState createState() => _showState();
}

class _showState extends State<NewsShow> {
  // This will give them 80% width which will allow other slides to appear on the side
  final PageController controller = PageController(viewportFraction: 0.8);


  final Firestore datbase = Firestore.instance;
  Stream slides;
  String activeTag = 'favourites';

  int currentPage = 0;


  FirebaseUser currentuser;
  bool _admin = false;


  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
    _queryDatabase();
    controller.addListener(() {
      int next = controller.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }

  void _adminControl(){

    try{
      if(currentuser.uid.toString()=='Zr7nzw7AjjZi3G90rHp6SEtdwBJ3'){

        setState(() {
          _admin=true;
        });
      }
    }catch(e){

    }

  }





  void _queryDatabase({String tag = 'favourites'}) {
    Query query =
    datbase.collection('News').orderBy('timestamp',descending: false);
    // Map the slides to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));
    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }

  Container _buildTagPage() {
    _adminControl();
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'News',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500,color: Colors.blue),
          ),
          Text(
            'say something about news here',
            style: TextStyle(color: Colors.blue),
          ),

          ButtonTheme(
            minWidth: 10,
            height: 10,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNews()),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.pinkAccent,
              textColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 2.0, vertical: 6.0),
                child: Text(" news",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer _buildStoryPage(Map data, bool active) {
    // Animated properties
    final double blur = active ? 10 : 0;
    final double offset = active ? 15 : 0;
    final double top = active ? 150 : 250;
    final double bottom = active ? 150 : 250;


    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: bottom, right: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(data['image_url']),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: blur,
              offset: Offset(offset, offset),
            ),
          ],
        ),
        child:InkWell(
            onTap: ()=> Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebViewPage(data['link'])),
            ),
            child:Wrap(
          children: <Widget>[

            Padding(padding: EdgeInsets.all(30),
              child: Text(data['desc'],style: TextStyle(color: Colors.white,fontSize: 24),),
            ),

          ],

        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.lightBlue),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body:StreamBuilder(
          stream: slides,
          initialData: [],
          builder: (context, AsyncSnapshot snap) {
            List slideList = snap.data.toList();
            return PageView.builder(
              controller: controller,
              itemCount: slideList.length + 1,
              itemBuilder: (context, int currentIndex) {
                if (currentIndex == 0) {
                  return _buildTagPage();
                } else if (slideList.length >= currentIndex) {
                  bool active = currentIndex == currentPage;
                  return _buildStoryPage(slideList[currentIndex - 1], active);
                }
              },
            );
          },
        ),
      ),
    );
  }
}