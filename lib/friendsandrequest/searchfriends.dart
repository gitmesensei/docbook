import 'package:docbook/friendsandrequest/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SearchFriend extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
}
class SearchFriends extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SearchFriends> {

  FirebaseUser currentuser;


  @override
  void initState() {
    super.initState();

    _loadCurrentUser();


  }

  void _loadCurrentUser()  {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser =  user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search users',),
        iconTheme: IconThemeData(color: Colors.lightBlue),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),color: Colors.lightBlue, onPressed: (){})
        ],

      ),
      body: (friends()),

    );
  }
  Widget friends() {
    try {
      String id2 = currentuser.uid.toString();
      return StreamBuilder(
          stream: Firestore.instance.collection('Users').where(
              'friends', arrayContains: id2).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('loading....'),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('please wait '),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    String userid = snapshot.data.documents[index].documentID;
                    return userid!=currentuser.uid.toString()?Container(
                      child: Column(
                        children: <Widget>[
                          _users(userid), /////top user profile image and name
                        ],

                      ),

                    ):SizedBox(width: 0.1,height: 0,);
                  }


              );
            }
            return Center(
              child: Text('loading..'),
            );
          });
    }catch(Exception){

    }
  }
  Widget _users(userid) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 10.0, top: 10.0),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(userid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading....');
            DocumentSnapshot user = snapshot.data;
            return user['user_id']!=currentuser.uid.toString()? InkWell(
              onTap: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(userid))
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                            image:user['image']!=''? NetworkImage(user['image']):AssetImage('assets/heart.gif',),
                            fit: BoxFit.cover),
                        border: Border.all(
                            width: 2.0,
                            color: Colors.lightBlue,
                            style: BorderStyle.solid),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1.0,
                              color: Colors.black12,
                              spreadRadius: 4.0)
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      user['name'],
                      style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ):SizedBox(width: 1,);
          }),
    );
  }


}



