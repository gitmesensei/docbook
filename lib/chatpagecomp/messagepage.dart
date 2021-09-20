import 'dart:io';
import 'dart:math';

import 'package:docbook/fullscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';




class MessagePage extends StatefulWidget {
  String userid;

  MessagePage(this.userid);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  FirebaseUser currentuser;
  bool isMe = false;
  String message;
  File _image=null;
  final messageController=TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadCurrentUser();

  }

  void _loadCurrentUser() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentuser = user;
      });
    });
  }

  _load() async{

    try{

      await
      Firestore.instance.collection("Users").document(currentuser.uid.toString())
          .updateData({"chatTime": Timestamp.now()});

      Firestore.instance.collection("Users").document(currentuser.uid.toString())
          .updateData({
        "chats": FieldValue.arrayUnion([widget.userid])
      });
      Firestore.instance.collection("Users").document(widget.userid)
          .updateData({"chatTime":Timestamp.now()});

      Firestore.instance.collection("Users").document(widget.userid)
          .updateData({
        "chats": FieldValue.arrayUnion([currentuser.uid.toString()])
      });



    }catch(e){

    }

  }
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = selected;
    });

    final String randomName = Random().nextInt(10000).toString();

    final Reference storageReference = FirebaseStorage.instance
        .ref().child("post_images").child(randomName + ".jpg");

    final UploadTask uploadTask = storageReference.putFile(
        _image);

    TaskSnapshot durl = await uploadTask;

    String url = await durl.ref.getDownloadURL();

    storetoDatabase(url);

  }
  void storetoDatabase(url) {

    Firestore.instance.collection('messages').document(
        currentuser.uid.toString()).collection(
        widget.userid).add({

      'message': url,
      "seen": false,
      "type": 1,
      "timestamp": Timestamp.now(),
      "from": currentuser.uid.toString(),
    });
    Firestore.instance.collection('messages').document(
        widget.userid).collection(
        currentuser.uid.toString()).add({

      'message': url,
      "seen": false,
      "type": 1,
      "timestamp": Timestamp.now(),
      "from": currentuser.uid.toString(),
    });

  }





  @override
  Widget build(BuildContext context) {
    _load();
    return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {

                          Navigator.pop(context);

                        }),
                    _usersImage(widget.userid),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _usersName(widget.userid),
                          Text('offine',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: _messages(widget.userid),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 4, bottom: 4, right: 4, top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    Expanded(
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only( top: 2,left:5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                                color: Colors.lightBlue, width: 2)),
                        child:TextField(
                          maxLines: null,
                          controller: messageController,
                          onChanged: (value) {

                            message = value;
                          },
                          decoration: InputDecoration(
                            hintText: ' type your message here...',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: IconButton(icon: Icon(Icons.camera_alt,color: Colors.grey,), onPressed: () {

                              _pickImage(ImageSource.gallery);

                            }),
                          ),
                        ),
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(left: 4),
                      child: IconButton(icon:Icon(Icons.send,color: Colors.lightBlue,) , onPressed: (){

                        if(message.isNotEmpty) {

                          Firestore.instance.collection('messages').document(
                              currentuser.uid.toString()).collection(
                              widget.userid).add({

                            'message': message,
                            "seen": false,
                            "type": 0,
                            "timestamp": Timestamp.now(),
                            "from": currentuser.uid.toString(),
                          });
                          Firestore.instance.collection('messages').document(
                              widget.userid).collection(
                              currentuser.uid.toString()).add({

                            'message': message,
                            "seen": false,
                            "type": 0,
                            "timestamp": Timestamp.now(),
                            "from": currentuser.uid.toString(),
                          });

                          messageController.clear();
                        }else{

                          return Text('enter some text');
                        }
                        return Text('enter text');

                      })
                    ),


                  ],
                ),
              )

            ],
          ),
        ));
  }

  Widget _usersImage(userid) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection('Users').document(userid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading....');
          DocumentSnapshot user = snapshot.data;
          return Container(
            margin: EdgeInsets.all(4),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 2.0, color: Colors.white, style: BorderStyle.solid),
              boxShadow: [
                BoxShadow(
                    blurRadius: 1.0, color: Colors.black12, spreadRadius: 4.0)
              ],
              image: DecorationImage(
                  image: NetworkImage(user['image']), fit: BoxFit.cover),
            ),
          );
        });
  }

  Widget _usersName(userid) {
    return StreamBuilder(
        stream:
        Firestore.instance.collection('Users').document(userid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) return new Text('Loading....');
          DocumentSnapshot user = snapshot.data;
          return Text(user['name'],
              style: TextStyle(fontSize: 16, color: Colors.white));
        });
  }

  Widget _messages(userid) {
    try {
      return StreamBuilder(
          stream: Firestore.instance
              .collection('messages')
              .document(currentuser.uid.toString())
              .collection(userid)
              .orderBy('timestamp',descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
            if (!snap.hasData) return new Text('....');
            return new ListView.builder(
                itemCount: snap.data.documents.length,
                primary: true,
                reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snap.data.documents[index];
                  Timestamp timestamp = ds['timestamp'];

                  if (ds['from'].toString() == currentuser.uid.toString()) {
                    isMe = true;
                  } else {
                    isMe = false;
                  }
                  return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: <Widget>[

                          _date(timestamp.millisecondsSinceEpoch),
                          Material(
                            borderRadius: isMe
                                ? BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            )
                                : BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0)),
                            elevation: 5.0,
                            color: isMe ? Colors.lightBlue : Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ds['type']==0 ?Text(
                                ds['message'],
                                style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black87,
                                    fontSize: 15.0),
                              ):InkWell(child: Image.network(
                                ds['message'],
                                width: 250.0,
                                fit: BoxFit.fill,
                              ),
                                onTap: (){

                                if(ds['type']==1){

                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreen(ds['message'])));
                                }



                                },
                              )
                            ),
                          ),
                        ],
                      ));
                });
          });
    } catch (e) {}
  }
  Widget _lastseen(){

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
