import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docbook/onboardingcomp/chooseusername.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validate/validate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';


class RegisterApp extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}
class _LoginData {
  String email = '';
  String password = '';
}

class _MyPageState extends State<RegisterApp> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _LoginData _data = new _LoginData();
  bool isLoading=false;
  String errorMessage;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      setState(() {
        isLoading=false;
      });
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 8) {
      setState(() {
        isLoading=false;
      });
      return 'The Password must be at least 8 characters.';
    }

    return null;
  }
  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.


      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: this._data.email,
          password:this._data.password,
      ).then((signedInUser){

        signedInUser.user.sendEmailVerification();

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChooseUsername()));

          }).catchError((e){
        setState(() {
          isLoading=false;
        });
        switch (e.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(errorMessage))
        );          });
    }else{
      setState(() {
        isLoading=false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new WillPopScope(
        onWillPop: ()async=>Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginApp()),
        ),
        child:Container(
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              body:SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 80,bottom: 20),
                child: Wrap(
                  children: <Widget>[
                    Stack(
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Center(child:
                          Container(
                            margin: EdgeInsets.only(top: 100,bottom: 20),
                            width: 300.0,
                            height: 450.0,
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
                                child: new Form(
                                  key: this._formKey,
                                  child: new ListView(
                                    children: <Widget>[

                                      SizedBox(
                                        height: 20,
                                      ),
                                      Theme(
                                        data: ThemeData(
                                          primaryColor: Colors.white,
                                        ),
                                        child: new TextFormField(
                                            keyboardType:
                                            TextInputType.emailAddress, // Us
                                            enableSuggestions: true,
                                            style: TextStyle(
                                                color: Colors
                                                    .white), // e// email input type for emails.
                                            decoration: new InputDecoration(
                                                labelText: 'E-mail Address',
                                                alignLabelWithHint: true,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide()),
                                                fillColor: Colors.white),
                                            validator: this._validateEmail,
                                            onSaved: (String value) {
                                              this._data.email = value;
                                            }),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Theme(data: ThemeData(
                                        primaryColor: Colors.white,
                                      ), child:
                                      new TextFormField(
                                          obscureText: true,
                                          style: TextStyle(color: Colors.white),
                                          decoration: new InputDecoration(
                                            labelText: 'Enter Your Password',
                                            focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.white)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide()),
                                          ),
                                          validator: this._validatePassword,
                                          onSaved: (String value) {
                                            this._data.password = value;
                                          }),),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      isLoading!=true? Container(
                                        width: screenSize.width,
                                        child: new RaisedButton(
                                          child: new Text(
                                            'Register',
                                            style: new TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            if(_data.email!=null||_data.password!=null){

                                              this.submit();
                                              setState(() {
                                                isLoading=true;
                                              });
                                            }

                                          },
                                          color: Colors.blue,
                                        ),
                                        margin: new EdgeInsets.only(top: 10.0),
                                      ):Center(child:CircularProgressIndicator(backgroundColor: Colors.white,),),
                                      Padding(padding: EdgeInsets.all(10.0),
                                          child:  Text('Or ',textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          )
                                      ),
                                      RaisedButton(  child: new Text(
                                        'Back To Login',
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
                                )),
                          ),
                          Center(
                            child: Text('Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 34.0,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
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
}