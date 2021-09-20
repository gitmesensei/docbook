import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validate/validate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';


class Forget extends StatefulWidget {
  @override
  _MyPState createState() => new _MyPState();
}
class _LoginData {
  String email = '';
}

class _MyPState extends State<Forget> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.


      FirebaseAuth.instance.sendPasswordResetEmail(
          email: this._data.email,
      ).then((_){

        emailsent();


      }).catchError((e){
        return e;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new WillPopScope(
        onWillPop: ()async=>Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginApp()),
        ),
        child:Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backdoc.jpg'),
                  fit: BoxFit.cover),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body:SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 60,bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[

                          Center(child:
                          Container(
                            margin: EdgeInsets.only(top: 100),
                            width: 300.0,
                            height: 450.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(colors: [
                                  Colors.white,Colors.lightBlueAccent,Colors.lightBlue,
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(3.0, 6.0),
                                      blurRadius: 10.0)
                                ]
                            ),
                            child: Container(
                                padding: new EdgeInsets.only(top: 50.0,left: 20.0,right: 20.0),
                                child: new Form(
                                  key: this._formKey,
                                  child: new ListView(
                                    children: <Widget>[

                                      Container(
                                        padding: EdgeInsets.all(5),

                                        child: Text('reset password link will be sent to your\n   registered email address, enter your\n      registered email address below'),
                                      ),
                                      new TextFormField(
                                          keyboardType: TextInputType.emailAddress, // Use email input type for emails.
                                          decoration: new InputDecoration(
                                              hintText: 'you@example.com',
                                              labelText: 'E-mail Address',fillColor: Colors.white
                                          ),
                                          validator: this._validateEmail,
                                          onSaved: (String value) {
                                            this._data.email = value;
                                          }
                                      ),
                                      new Container(

                                        width: screenSize.width,
                                        child: new RaisedButton(
                                          child: new Text(
                                            'submit',
                                            style: new TextStyle(
                                                color: Colors.white
                                            ),
                                          ),
                                          onPressed: this.submit,
                                          color: Colors.blue,
                                        ),
                                        margin: new EdgeInsets.only(
                                            top: 20.0
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(2.0),
                                          child:  Text('or ',textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          )
                                      ),
                                      RaisedButton(  child: new Text(
                                        'back to Login',
                                        style: new TextStyle(
                                            color: Colors.blue
                                        ),
                                      ),
                                        onPressed:(){ Navigator.pop(context);
                                        },
                                        color: Colors.white,),


                                    ],
                                  ),
                                )

                            ),
                          ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 60),
                              width: 80,
                              height: 80,
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
                          Center(
                            child: Text('Reset Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          )
    );
  }

  void emailsent(){
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text("Reset link have been sent to your registered email address, click on the link to reset your password"),
      actions: [ CupertinoDialogAction(
      isDefaultAction: true,
      child: Text("ok"),
      onPressed: () {

        Navigator.pop(context);

      }
      )
    ],
      )
    );
  }
}