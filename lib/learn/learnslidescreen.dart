import 'package:docbook/webview.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class LearnSlideshow extends StatefulWidget {
  @override
  _SshowState createState() => _SshowState();
}

class _SshowState extends State<LearnSlideshow> {
  // This will give them 80% width which will allow other slides to appear on the side
  final PageController controller = PageController(viewportFraction: 0.8);


  final Firestore datbase = Firestore.instance;
  Stream slides;
  String activeTag = 'favourites';

  int currentPage = 0;


  FirebaseUser currentuser;


  @override
  void initState() {
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





  void _queryDatabase({String tag = 'favourites'}) {
    Query query =
    datbase.collection('Learn').orderBy('timestamp',descending: true);
    // Map the slides to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));
    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }

  AnimatedContainer _buildTagPage() {
    // Animated properties
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: 100, bottom: 100, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.lightBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(20, 20),
          ),
        ],
      ),
      child: Padding(padding: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[

          Padding(padding: EdgeInsets.only(right: 5),
          child:Icon(Icons.arrow_back, size:30,color: Colors.white,),
          ),

          Text("slide to check news",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontFamily: "Calibre-Semibold",
                letterSpacing: 1.0,
              )),
        ],
      ),
      ),
    );
  }

  FlatButton _buildButton(tag) {
    Color color = tag == activeTag ? Colors.blue : Colors.white;
    return FlatButton(
      color: color,
      child: Text(
        '#$tag',
        textAlign: TextAlign.left,
      ),
      onPressed: () => _queryDatabase(tag: tag),
    );
  }

  AnimatedContainer _buildStoryPage(Map data, bool active) {
    // Animated properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 10 : 50;


    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(data['image_url'],
          ),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
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
                  child: Text(data['desc'],style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
        child:StreamBuilder(
      stream: slides,
      initialData: [],
      builder: (context, AsyncSnapshot snap) {
        List slideList = snap.data.toList();
        return PageView.builder(
          controller: controller,
          itemCount: slideList.length  ,
          itemBuilder: (context, int currentIndex) {
            bool active = currentIndex == currentPage;
            if (currentIndex == 0) {
              return _buildStoryPage(slideList[0], active);
            } else if (slideList.length >= currentIndex) {
              return _buildStoryPage(slideList[currentIndex], active);
            }
          },
        );
      },
    ),
    );
  }
}