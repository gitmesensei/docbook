import 'package:docbook/friendsandrequest/otheruserposts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePageRequest extends StatefulWidget {
  final String userid;
  ProfilePageRequest(this.userid, {Key key}) : super(key: key);

  @override
  _FourthState createState() => _FourthState();
}

class _FourthState extends State<ProfilePageRequest> {

  FirebaseUser currentuser;
  int request;
  int friends;


  @override
  void initState() {
    super.initState();

    _loadCurrentUser();
    checkRequest();

  }
  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }
  void checkRequest()async{

    try {
      final QuerySnapshot result = await Firestore.instance
          .collection('Users')
          .where('request_sent', arrayContains: currentuser.uid.toString())
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      print(documents.length);
      setState(() {
        this.request= documents.length;
      });
    }catch(e){


    }

  }


  DocumentSnapshot profile;

  @override
  Widget build(BuildContext context) {

    try {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.lightBlue),
            title: Text(
              'Users Profile',
              style: TextStyle(color: Colors.lightBlue),
            ),
          ),
          body: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: <Widget>[
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('Users')
                      .document(widget.userid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snap) {
                    if (!snap.hasData) return new Text('Loading....');
                    this.profile = snap.data;
                    String username = profile['username'].toString().toLowerCase();
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
                                  EdgeInsets.only(top: 25, left: 5, right: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Center(child:
                                  Padding(
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    child: Text(profile['name'].toString().toUpperCase(),
                                        style:
                                        TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500)),
                                  ),
                                  ),
                                  Center(child:
                                  Padding(
                                    padding: EdgeInsets.only(left: 5,right: 5,top: 5),
                                    child: Text('@$username',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  ),
                                ],
                              )
                            ),
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
                                image:profile['image']!=''? NetworkImage(profile['image']):AssetImage('assets/heart.gif',),
                                fit: BoxFit.cover),
                          ),
                        )),
                        Column(
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.only(left: 10,top: 268),
                              child: _addRemovefriend(),
                            ),

                            profile['status']!=''? Center(child:
                            Padding(
                              padding: EdgeInsets.only(top: 10,left: 5,right: 5),
                              child: Text('$status',
                                  style: TextStyle(color: Colors.lightBlue)),
                            ),
                            ):SizedBox(height: 0.1,),

                            profile['bio']!=''?
                            Center(child:
                            Padding(
                              padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                              child: Text('$bio',
                                style: TextStyle(color: Colors.lightBlue,),textAlign: TextAlign.center,),
                            ),
                            ):SizedBox(height: 0.1,),

                            profile['profession']!=''?Align(
                              alignment: Alignment.centerLeft,
                              child:
                              Padding(
                                  padding: EdgeInsets.only(top: 20,left: 10,right: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'Profession:  ',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.pinkAccent)),
                                        TextSpan(text: profile['profession'],style: TextStyle(color: Colors.lightBlue,))
                                      ],
                                    ),
                                  )
                              ),
                            ):SizedBox(height: 0.1,),
                            profile['workat']!=''? Align(
                              alignment: Alignment.centerLeft,
                              child:
                              Padding(
                                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'Work At:  ',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.pinkAccent)),
                                        TextSpan(text: profile['workat'],style: TextStyle(color: Colors.lightBlue,))
                                      ],
                                    ),
                                  )
                              ),
                            ):SizedBox(height: 0.1,),

                            profile['college']!=''?Align(
                              alignment: Alignment.centerLeft,
                              child:
                              Padding(
                                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'college:  ',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.pinkAccent)),
                                        TextSpan(text: profile['college'],style: TextStyle(color: Colors.lightBlue,))
                                      ],
                                    ),
                                  )
                              ),
                            ):SizedBox(height: 0.1,),

                            profile['dob']!=''? Align(
                              alignment: Alignment.centerLeft,
                              child:
                              Padding(
                                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: 'DOB:  ',style: TextStyle(fontWeight: FontWeight.w500,color: Colors.pinkAccent)),
                                        TextSpan(text: profile['dob'],style: TextStyle(color: Colors.lightBlue,))
                                      ],
                                    ),
                                  )
                              ),
                            ):SizedBox(height: 0.1,),

                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: ProfileUserPosts(widget.userid),
                            )
                          ],
                        )
                      ],
                    );
                  }
                  ),
            ],
          ),
        ),
      );
    } catch (Exception) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _addRemovefriend() {

    return   request!=0? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ButtonTheme(
               minWidth: 10,
               height: 10,
               child: RaisedButton(
                 onPressed: () {

                   Firestore.instance.collection('Users').document(widget.userid).updateData({

                     'friends':FieldValue.arrayUnion([currentuser.uid.toString()])

                   }).then((_) => {

                     Firestore.instance.collection('Users').document(currentuser.uid.toString()).updateData({

                       'friends':FieldValue.arrayUnion([widget.userid.toString()])

                     })


                   }).then((_){

                     Firestore.instance.collection('Users').document(widget.userid).updateData({

                       'request_sent':FieldValue.arrayRemove([currentuser.uid.toString()])

                     }).then((_){

                       setState(() {
                         this.friends=1;
                       });
                     });
                   });
                 },
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30.0)),
                 color: Colors.lightBlue,
                 textColor: Colors.white,
                 elevation: 0,
                 child: Padding(
                   padding:
                   EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
                   child: Text("accept",
                       style: TextStyle(color: Colors.white)),
                 ),
               ),
             ),
             ButtonTheme(
               minWidth: 10,
               height: 10,
               child: RaisedButton(
                 onPressed: () {

                   Firestore.instance.collection('Users').document(widget.userid).updateData({

                   'request_sent':FieldValue.arrayRemove([currentuser.uid.toString()])

                 }).then((_){

                   setState(() {
                     this.request=0;
                   });
                 });
                 },
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(30.0)),
                 color: Colors.pinkAccent,
                 textColor: Colors.white,
                 elevation: 0,
                 child: Padding(
                   padding:
                   EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
                   child: Text("delete",
                       style: TextStyle(color: Colors.white)),
                 ),
               ),
             )

        ],
    ):friends==0?ButtonTheme(
      minWidth: 10,
      height: 10,
      child: RaisedButton(
        onPressed: () {


          Firestore.instance.collection('Users').document(widget.userid).updateData({

            'request_sent':FieldValue.arrayUnion([currentuser.uid.toString()])

          }).then((_){

            setState(() {
              this.friends=1;
            });
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
        color: Colors.lightBlue,
        textColor: Colors.white,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
          child: Text("follow",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    ):ButtonTheme(
      minWidth: 10,
      height: 10,
      child: RaisedButton(
        onPressed: () {


          Firestore.instance.collection('Users').document(widget.userid).updateData({

            'request_sent':FieldValue.arrayRemove([currentuser.uid.toString()])

          }).then((_){

            setState(() {
              this.friends=0;
            });
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
        color: Colors.lightBlue,
        textColor: Colors.white,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
          child: Text("request sent",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );

  }
}
