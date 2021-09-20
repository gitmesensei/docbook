import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'messagepage.dart';

class UserChats extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<UserChats> {
  FirebaseUser currentuser;
  DocumentSnapshot doc;
  int docum;
  Timestamp timestamp;
  bool seen;
  var type;

  @override
  void initState() {
    super.initState();

    _loadCurrentUser();
  }

  bool isSwitched = true;

  var _color=Colors.grey;

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.lightBlue),
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Text('Chats',style: TextStyle(color: Colors.lightBlue),),
        ),

        body:Container(
        decoration: BoxDecoration(
        ),
        child:ListView(
      primary: true,
      padding: EdgeInsets.only( top: 0.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 0.0),
          child: chats(),
        )
      ],
        )
    )
    );
  }

  Widget chats() {
    try {
      String id2 = currentuser.uid.toString();
      return StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .where('chats', arrayContains: id2)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator()
              );
            }else if(snapshot.data.documents.isEmpty) {
              return  Padding(
                  padding: EdgeInsets.only(top: 200,left: 20,right: 20),
                  child:Container(
                    width: 300,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10
                          )
                        ],
                        borderRadius: BorderRadius.circular(30)
                    ),                    child: Center(
                    child:  Text(' you do not have any conversation',style: TextStyle(color: Colors.lightBlueAccent)),
                  ),
                  )
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 5),
                  primary: false,
                  itemBuilder: (context, index) {
                    String userid = snapshot.data.documents[index].documentID;
                    return new AnimatedContainer(
                        duration: Duration(seconds: 2),
                        curve: Curves.easeOutQuint,
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.only( bottom: 5,left: 5,right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 0.5
                            )
                          ]
                        ),
                        child:ListTile(
                          leading:_usersImage(userid),
                          title: Row(
                            children: <Widget>[

                              Expanded(child: _usersName(userid),
                              ),

                              SizedBox(
                                width: 16.0,
                              ),
                              Expanded(child: _timestamp(userid)),
                            ],
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Expanded(child:_message(userid) ),

                              Expanded(child:_m(userid), ),

                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,color: Colors.lightBlue,
                          ),
                          onTap: (){

                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagePage(userid)));

                          },
                          onLongPress: (){

                            //chat delete here with dialog
                          },
                        )
                    );
                  }
                    );

            }
            return Center(
              child: Text(''),
            );
          });
    } catch (Exception) {}
  }

  Widget _usersImage(userid) {
    return StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(userid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading....');
            DocumentSnapshot user = snapshot.data;
            return ClipOval(
              child: Image(
                image: NetworkImage(user['image']),));
          }
    );
  }

  Widget _usersName(userid) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(userid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading....');
          DocumentSnapshot user = snapshot.data;
          return Text(user['name'],style: TextStyle(color: Colors.lightBlue),);
        }
    );
  }

  Widget _m(userid) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(currentuser.uid.toString())
            .collection(userid).where('from',isEqualTo: userid)
            .where('seen',isEqualTo: false)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {

          try{
            setState(() {
              this.docum = snapshot.data.documents.length;
              this.seen=doc['seen'];
            });
          }catch(e){

          }
          if(snapshot.connectionState==ConnectionState.waiting) return Text('.....');
          if (!snapshot.hasData) return new Text('Loading....');
           return Padding(padding: EdgeInsets.only(left: 10),
            child: Text(docum==0?'':'',style: TextStyle(color:Colors.grey),),
          );
        }
    );

  }

  Widget _message(userid) {
    return StreamBuilder(
        stream: Firestore.instance
        .collection('messages')
        .document(currentuser.uid.toString())
        .collection(userid).orderBy('timestamp')
        .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          try{
            setState(() {
              this.doc =  snapshot.data.documents.last;
              this.seen=doc['seen'];
              this.type=doc['type'];
            });
          }catch(e){

          }

          if(snapshot.connectionState==ConnectionState.waiting) return Text('.....');
          if (!snapshot.hasData)return new Text('Loading....');
          return Text( type==0?doc['message']:'photo',style: TextStyle(color:Colors.grey));
        }
    );
  }
  _timestamp(userid) {

    return StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(userid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot snapshot) {
          try{
            setState(() {
              this.doc =  snapshot.data;
              this.timestamp = doc['chatTime'];

            });
          }catch(e){

          }
          if(snapshot.connectionState==ConnectionState.waiting) return Text('.....');
          if (!snapshot.hasData)return new Text('Loading....');
          if (snapshot.hasData)return _date(timestamp.millisecondsSinceEpoch);
          return Text('...');
        }
    );


  }
  Widget _date(timestamp){

    var now = new DateTime.now();
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var format = new DateFormat('HH:mm a');
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return Text(time.toLowerCase(),style: TextStyle(fontSize: 12,color: Colors.grey),);

  }


}
