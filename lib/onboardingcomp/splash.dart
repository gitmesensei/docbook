import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:docbook/main.dart';
import 'package:docbook/onboardingcomp/intropage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';


class SplashScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SplashScreen> with SingleTickerProviderStateMixin {


  AnimationController controller;


  FirebaseUser currentuser;

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });

  }
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration,_navigate);
  }


  @override
  void initState() {
    super.initState();
    startTime();

    controller =
        AnimationController(duration: Duration(seconds: 4), vsync: this);

    _loadCurrentUser();

  }


  void _navigate() async{

    await FirebaseAuth.instance.currentUser().then((FirebaseUser user){

      if(user!= null){
        Firestore.instance.collection('Users').document(user.uid.toString()).get().then((DocumentSnapshot snap){

          if(snap.exists){
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>MyApp()));

          }else{

            FirebaseAuth.instance.signOut().then((_){

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginApp()));

            });

          }
        });
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>IntroPage()));
      }

    });


  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward(from: 0.0);
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            Container(
              margin: EdgeInsets.only(left: 20,right: 20,bottom: 5),
              child: Text('DocBook',
                style: TextStyle(
                    fontFamily: 'Quicksand',
                    color: Colors.lightBlue,
                    fontSize: 40.0,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold),),
            ),

            RotationTransition(turns: Tween(begin: 0.0,end: 3.0).animate(controller),
              child: Container(
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
                          spreadRadius: 2.0)
                    ]),
                child: ImageIcon(
                  new AssetImage('assets/logo.png'),
                  color: Colors.white,
                  size: 50.2,
                ),
              ),
            )

          ],
          )
      ),
    );
  }
}