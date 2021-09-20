import 'package:docbook/friendsandrequest/profilepage.dart';
import 'package:docbook/webview.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'comments/comments.dart';
import 'package:recase/recase.dart';


class Postsless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  FirebaseUser currentuser;
  String currentid;
  int likesCount;
  final myController = TextEditingController();
  String comment;
  bool isLiked;



  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    try{

      setState(() {
        this.currentid = currentuser.uid.toString();
      });

    }catch(e){


    }

    return new Padding(
        padding: EdgeInsets.only(bottom: 54),
        child: StreamBuilder(
            stream: Firestore.instance
                .collection("Users")
                .where('friends', arrayContains: currentid )
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
              if (!snap.hasData)
                return new Center(
                  child: CircularProgressIndicator(),
                );
              if(snap.connectionState==ConnectionState.waiting){
                return new Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snap.data.documents.length == null
                      ? 0
                      : snap.data.documents.length,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String id = snap.data.documents[index].documentID;
                    DocumentSnapshot user = snap.data.documents[index];

                    return StreamBuilder(
                        stream: Firestore.instance
                            .collection("Users")
                            .document(id)
                            .collection('Posts')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snap) {
                          if (!snap.hasData)
                            return new Center(
                              child: CircularProgressIndicator(),
                            );
                          if(snap.connectionState==ConnectionState.waiting){
                            return new Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                              itemCount: snap.data.documents.length == null
                                  ? 0
                                  : snap.data.documents.length,
                              scrollDirection: Axis.vertical,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                String blogid =
                                    snap.data.documents[index].documentID;
                                DocumentSnapshot ds =
                                    snap.data.documents[index];

                                return Container(
                                  width: 80,
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                     border: Border.all(width:Theme.of(context).brightness==Brightness.dark?2:1,color:Colors.white),
                                     color:Theme.of(context).brightness==Brightness.dark?Colors.black87:Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Wrap(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          user['user_id'] ==
                                                  currentuser.uid.toString()
                                              ? null
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(user[
                                                              'user_id'])));
                                        },
                                        child:Padding(padding: EdgeInsets.only(
                                            bottom: 10.0, left: 10.0, top: 10.0),child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            new Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  image: DecorationImage(
                                                      image: user['image'] != ''
                                                          ? NetworkImage(
                                                              user['image'])
                                                          : AssetImage(
                                                              'assets/heart.gif',
                                                            ),
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
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                user['name'].toString().titleCase,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.lightBlue),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.0, right: 10.0,bottom: 0,top: 10),
                                              child: ds['desc'] == null
                                                  ? Text('')
                                                  : Text(
                                                ds['desc'],
                                                style: TextStyle(
                                                    color: Colors.lightBlue,
                                                    fontSize: 15,
                                                    textBaseline: TextBaseline
                                                        .alphabetic),
                                              )),
                                          InkWell(
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 10.0,top: 10),
                                                child: ds['link'] == ''
                                                    ? Text('')
                                                    : RichText(text: TextSpan(
                                                    children: [
                                                      TextSpan(text:'Link :',style: TextStyle(color: Colors.pinkAccent,)),
                                                      TextSpan(text: ds['link'],
                                                        style: TextStyle(decoration: TextDecoration.underline,
                                                          color: Colors.lightBlueAccent,
                                                          textBaseline: TextBaseline.alphabetic,),
                                                      )
                                                    ]
                                                ),
                                                  textAlign: TextAlign.start,
                                                )),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebViewPage(ds['link'])));
                                            },
                                          ),
                                        ],
                                      ),

                                      Container(
                                          padding: EdgeInsets.all(10),
                                          child: ds['image_url'] == null
                                              ? Text('')
                                              : Image(
                                                  image: NetworkImage(
                                                      ds['image_url']))),
                                      Padding(
                                          padding: EdgeInsets.only(left: 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              _likes(ds,blogid),
                                              _comments(blogid,id,ds),
                                            ],
                                          )),
                                    ],
                                  ),
                                );
                              });
                        });
                  });
            }));
  }

  Widget _likes(ds,blogid) {

    dynamic likes = ds['likes'];
    isLiked = (likes[currentid] == true);

    int count = 0;

    if (likes == null) {

      count=0;
    }
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });


    return Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: IconButton(
                      icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.pinkAccent : Colors.grey),
                      onPressed: () {
                         bool _isLiked = likes[currentid] == true;

                          if (_isLiked) {
                            Firestore.instance.collection('Users')
                                .document(ds['user_id'])
                                .collection('Posts')
                                .document(blogid)
                                .updateData({'likes.$currentid': false});
                            setState(() {
                              count -= 1;
                              isLiked = false;
                              likes[currentid] = false;
                            });
                          } else if (!_isLiked) {
                            Firestore.instance.collection('Users')
                                .document(ds['user_id'])
                                .collection('Posts')
                                .document(blogid)
                                .updateData({'likes.$currentid': true});
                            setState(() {
                              count += 1;
                              isLiked = true;
                              likes[currentid] = true;
                            });
                          }
                      }

                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.0),
                  child: Text(count.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                )
    ]);
  }

  Widget _comments(blogid,id,ds) {
    return Row(children: <Widget>[
      StreamBuilder(
        stream: Firestore.instance
            .collection('Users').document(id).collection('Posts')
            .document(blogid)
            .collection('Comments')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            int count = snapshot.data.documents.length;
            return new Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.comment,
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.95,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child:Comments(blogid, id, ds)
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            );
          } else {
            return new Text('');
          }
        },
      ),
    ]);
  }
}
