import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/learn/addlearn.dart';
import 'package:docbook/learn/learnslidescreen.dart';
import 'package:flutter/material.dart';

import '../webview.dart';

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.only(top: 0, bottom: 50),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/learnback.jpg'),
                        fit: BoxFit.cover)),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.45)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Learn Something new',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Compete in all new Quizzes ! !',
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20,top: 20,bottom: 0),
            child: Row(
              children: <Widget>[
                Text("Trending",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 25.0,
                      letterSpacing: 1.0,
                    )),
                Icon(Icons.trending_up,size: 30,color: Colors.pinkAccent,),

                SizedBox(width: 10,),

                IconButton(icon: Icon(Icons.add), onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddLearn()));

                })

              ],
            ),
          ),

          LearnSlideshow()
        ],
      ),
    );
  }
}
