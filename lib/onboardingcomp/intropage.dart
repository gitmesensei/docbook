import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validate/validate.dart';

import 'login.dart';


class IntroPageless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
    );
  }
}

class IntroPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<IntroPage>
    with TickerProviderStateMixin {
  Animation cardAnimation, delayedCardAnimation, fabButtonanim, infoAnimation,logoanim,formanimation;
  AnimationController controller;
  AnimationController _subheadingController;
  Animation<double> _subheadingOpacity;

  AnimationController _headingController;
  Animation<double> _headingOpacity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    controller.forward();

    cardAnimation = Tween(begin: 0.0, end: -0.025).animate(
        CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller));

    delayedCardAnimation = Tween(begin: 0.0, end: -0.05).animate(
        CurvedAnimation(
            curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   ),
            parent: controller));

    fabButtonanim = Tween(begin: 1.0, end: -0.0008).animate(CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
        parent: controller));

    logoanim = Tween(begin: -1.0, end: -0.0008).animate(CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.bounceInOut),
        parent: controller));

    formanimation = Tween(begin: -1.0, end: 0.0008).animate(CurvedAnimation(
        curve: Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
        parent: controller));
    infoAnimation = Tween(begin: 0.0, end: 0.025).animate(CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
        parent: controller));
    _subheadingController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _subheadingOpacity =
    new CurvedAnimation(parent: _subheadingController, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _subheadingController.dispose();
        } else if (status == AnimationStatus.dismissed) {
          _subheadingController.forward();
        }
      });
    _subheadingController.forward();

    _headingController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _headingOpacity =
    new CurvedAnimation(parent: _headingController, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _headingController.dispose();
        } else if (status == AnimationStatus.dismissed) {
          _headingController.forward();
        }
      });
    _headingController.forward();
  }
  @override
  void dispose() {
    controller.dispose();
    _subheadingController.dispose();
    _headingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery
        .of(context)
        .size
        .height;
    return new WillPopScope(
        onWillPop: ()async=> SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    child:AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Container(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                 children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(top: 30.0,bottom: 40),
                     alignment: Alignment.center,
                     child: Stack(
                       overflow: Overflow.visible,
                       children: <Widget>[
                         Center(
                           child:Container(
                             margin: EdgeInsets.only(top: 150),
                           width: 300.0,
                           height: 450.0,
                           transform: Matrix4.translationValues(0.0, delayedCardAnimation.value * devHeight, 0.0),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20.0),
                              color: Colors.lightBlue,
                               boxShadow: [
                                 BoxShadow(
                                     color: Colors.black26,
                                     offset: Offset(3.0, 6.0),
                                     blurRadius: 10.0)
                               ]
                           ),
                           child: Container(
                             padding: new EdgeInsets.only(top: 50.0,left: 20.0,right: 20.0),
                             transform: Matrix4.translationValues(0.0,formanimation.value * devHeight , 0.0),
                             child: Padding(
                               padding: const EdgeInsets.only(top: 20.0),
                               child: new Center(
                                 child: Column(
                                   children: <Widget>[
                                     new FadeTransition(
                                       opacity: _headingOpacity,
                                       child: new Text(
                                         'Hi there,',
                                         style: new TextStyle(
                                             color: Colors.white,
                                             fontSize: 40.0,
                                             fontFamily: "Signika",
                                             fontWeight: FontWeight.w600),
                                       ),
                                     ),
                                     new FadeTransition(
                                       opacity: _headingOpacity,
                                       child: new Text(
                                         "I'm Docbook",
                                         style: new TextStyle(
                                             color: Colors.white,
                                             fontSize: 40.0,
                                             fontFamily: "Signika",
                                             fontWeight: FontWeight.w600),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(top: 64.0),
                                       child: new FadeTransition(
                                         opacity: _subheadingOpacity,
                                         child: new Text(
                                           "Your new exclusive",
                                           style: new TextStyle(
                                               color: Colors.white,
                                               fontSize: 25.0,
                                               fontFamily: "Signika",
                                               fontWeight: FontWeight.w300),
                                         ),
                                       ),
                                     ),
                                     new FadeTransition(
                                       opacity: _subheadingOpacity,
                                       child: new Text(
                                         "medical community",
                                         style: new TextStyle(
                                             color: Colors.white,
                                             fontSize: 25.0,
                                             fontFamily: "Signika",
                                             fontWeight: FontWeight.w300),
                                       ),
                                     ),
                                     new Padding(padding: EdgeInsets.only(top: 64.0)),
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         ),
                         ),
                         Center(
                           child: Padding(padding: EdgeInsets.only(top: 0),
                             child: Text('DocBook',
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 fontSize: 34.0,
                                 color: Colors.lightBlue,
                                 fontWeight: FontWeight.bold
                               ),
                             ),

                           )
                         ),
                         Hero(tag: 'logo', child:
                         Center(
                           child: Container(
                             margin: EdgeInsets.only(top: 70),
                             width: 80,
                             height: 80,
                             transform: Matrix4.translationValues(0.0,logoanim.value * devHeight , 0.0),
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Colors.lightBlue,
                                 border: Border.all(width: 2.0,color: Colors.white,style: BorderStyle.solid),
                                 boxShadow: [
                                   BoxShadow(
                                       blurRadius: 1.0,
                                       color: Colors.black12,
                                       spreadRadius: 4.0)
                                 ]
                             ),
                             child:   ImageIcon(
                               new AssetImage('assets/logo.png'),
                               color: Colors.white,
                               size: 50.2,
                             ),
                           ),
                         ),
                         ),

                         Center(
                           child: Container(
                             margin: EdgeInsets.only(top: 490),
                             transform: Matrix4.translationValues(0.0, infoAnimation.value * devHeight, 0.0),
                             width: 270.0,
                             height: 90.0,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10.0),
                                 color: Colors.white,
                                 boxShadow: [
                                   BoxShadow(
                                       blurRadius: 1.0,
                                       color: Colors.black12,
                                       spreadRadius: 2.0)
                                 ]),
                             child: Padding(padding:EdgeInsets.all(20.0),
                               child: new RaisedButton(
                                 onPressed: (){
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             LoginApp()),
                                   );
                                 },
                                 elevation: 15.0,
                                 color: Colors.blue,
                                 textColor: Colors.white,
                                 shape: new RoundedRectangleBorder(
                                     borderRadius: new BorderRadius.circular(30.0)),
                                 child: Text(
                                   "Let's Go!",
                                   style: TextStyle(fontSize: 20.0, fontFamily: "Signika"),
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   new Text(
                     "  By creating a new acount or signing in with Facebook you are agreeing to our terms  \n of service and privacy policy",
                     style: new TextStyle(
                       color: Colors.pinkAccent,
                       fontSize: 10.0,
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ],
                //first column children
              ),
            ),
          );
        }
        )
    );
  }
}