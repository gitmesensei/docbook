import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Commentsless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Comments extends StatefulWidget {
  final String blogid;
  final String id;
  final DocumentSnapshot ds;

  Comments(this.blogid, this.id, this.ds, {Key key}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final myController = TextEditingController();
  String comment;
  FirebaseUser currentuser;
  int likesCount;
  bool isLiked;

  String currentid;

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
  void dispose() {
    // TODO: implement dispose

    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      setState(() {
        this.currentid = currentuser.uid.toString();
      });
    } catch (e) {}
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    InkWell(
                      splashColor: Colors.lightBlue,
                      onTap: () {
                      },
                      child: Row(
                        children: [
                          _likes(widget.ds, widget.blogid),
                          SizedBox(
                            width: 10,
                          ),
                          _comments()
                        ],
                      ),
                    )
                  ],
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('Users')
                        .document(widget.id)
                        .collection('Posts')
                        .document(widget.blogid)
                        .collection('Comments')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return new Text('loading...please wait');
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              DocumentSnapshot docs = snapshot.data.documents[index];
                              return _users(docs);
                            });
                      }
                      return Text('loading');
                    }),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 0, left: 10),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border:
                                Border.all(width: 2, color: Colors.lightBlue),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: TextField(
                          maxLines: null,
                          controller: myController,
                          onChanged: (value) {
                            comment = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Type your comment here...',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: Colors.lightBlue,
                            ),
                            onPressed: () {
                              if (comment.isNotEmpty) {
                                Firestore.instance.collection('Users').document(widget.id)
                                    .collection('Posts')
                                    .document(widget.blogid)
                                    .collection('Comments')
                                    .add({
                                  'message': comment,
                                  'user_id': currentuser.uid.toString(),
                                  'timestamp': Timestamp.now(),
                                });
                                myController.clear();
                              } else {
                                return Text('enter some text');
                              }
                              return Text('enter text');
                            })),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _likes(ds, blogid) {
    dynamic likes = ds['likes'];

    isLiked = (likes[currentid] == true);

    int count = 0;

    if (likes == null) {
      count = 0;
    }
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });

    return Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 2),
        child: IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.pinkAccent : Colors.grey),
            onPressed: () {}),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0),
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.grey),
        ),
      )
    ]);
  }

  Widget _comments() {
    return Row(children: <Widget>[
      StreamBuilder(
        stream: Firestore.instance
            .collection('Users')
            .document(widget.id)
            .collection('Posts')
            .document(widget.blogid)
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
                    onPressed: () {},
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
            return new Text('loading....please wait');
          }
        },
      ),
    ]);
  }

  Widget _users(docs) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 10.0, top: 0.0),
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('Users')
              .document(docs['user_id'])
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading....');
            DocumentSnapshot user = snapshot.data;
            return ListTile(
              leading: ClipOval(
                child: Image.network(user['image']),
              ),
              title: Text(user['name']),
              subtitle: Text(docs['message']),
            );
          }),
    );
  }
}
