import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';

import '../main.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}
class _EditProfileState extends State<EditProfile> {
  String username = '';
  String name = '';
  String status = '';
  String bio = '';
  String profession = '';
  String workat = '';
  String college = '';
  String dob = '';

  File _image = null;
  DocumentSnapshot profile;
  int check;
  FirebaseUser currentuser;
  String useridnow;

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

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
        ),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0));

    setState(() {
      _image = cropped ?? _image;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = selected;
    });
    _cropImage();
  }

  Future _uploadImage() async {
    if (_image != null) {
      final String randomName = Random().nextInt(10000).toString();

      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("post_images")
          .child(randomName + ".jpg");

      final UploadTask uploadTask = storageReference.putFile(_image);

      TaskSnapshot durl = await uploadTask;

      String url = await durl.ref.getDownloadURL();

      submit(url);
    } else {
      submit(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    try{

      this.useridnow=currentuser.uid.toString();

    }catch(e){

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.lightBlue),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.lightBlue),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection('Users')
                    .document(useridnow)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snap) {
                  if (!snap.hasData)
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                 this.profile = snap.data;
                  String usernameS=profile['username'];
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
                      Center(child:
                      Container(
                        margin: EdgeInsets.only(top: 150),
                        child: ButtonTheme(
                          minWidth: 5,
                          height: 5,
                          child: RaisedButton(
                            onPressed: ()=>_pickImage(ImageSource.gallery),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.pinkAccent,
                            textColor: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.all(2.0),
                                child:Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[

                                    Icon(Icons.add_a_photo,color: Colors.white,),
                                    Text(" change image",
                                        style: TextStyle(color: Colors.white)),

                                  ],
                                )
                            ),
                          ),
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
                            ),
                            child:ClipOval(
                                child: _image==null?profile['image']!=null?Image.network(profile['image'],fit: BoxFit.cover,):AssetImage('assets/heart.gif'):
                                Image.file(_image,fit: BoxFit.cover,)
                            ) ,
                          )
                      ),

                      Padding(padding: EdgeInsets.only(top: 250,left: 20,right: 20,bottom: 50),
                      child:Form(
                          child: Column(
                        children: <Widget>[

                          Container(
                            child: Text('@$usernameS'),
                          ),
                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'name', labelText: 'Enter your name'),
                              initialValue: profile['name'],
                              onChanged: (String value) {
                                name = value;
                              }),
                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'status', labelText: 'Enter your status'),
                              initialValue: profile['status'],
                              onChanged: (String value) {
                                status = value;
                              }),
                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'bio', labelText: 'enter your bio here'),
                              initialValue: profile['bio'],
                              maxLines: 7,
                              maxLength: 300,
                              onChanged: (String value) {
                                bio = value;
                              }),

                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'profession', labelText: 'Enter your profession '),
                              initialValue: profile['profession'],
                              onChanged: (String value) {
                                profession = value;
                              }),
                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'work at', labelText: 'Enter where you work'),
                              initialValue: profile['workat'],
                              onChanged: (String value) {
                                workat = value;
                              }),
                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'college', labelText: 'Enter your college name'),
                              initialValue: profile['college'],
                              onChanged: (String value) {
                                college = value;
                              }),
                          new TextFormField(
                              decoration: new InputDecoration(
                                  hintText: 'name', labelText: 'Enter your Date of Birth'),
                              initialValue: profile['dob'],
                              onChanged: (String value) {
                                dob = value;
                              }),
                        ],
                      )
                      ),
                      )

                    ],
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'post',
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
          onPressed: ()=>_uploadImage(),
      ),
    );

  }


  void submit(url) async {
   await FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('Users')
          .document(user.uid.toString())
          .updateData({
        'name': name==''?profile['name']:name,
        'image': url == null? profile['image'] : url,
        'college': college==''?profile['college']:college,
        'profession':profession==''?profile['profession']:profession,
        'workat': workat==''?profile['workat']:workat,
        'dob': dob==''?profile['dob']:dob,
        'bio': bio==''?profile['bio']:bio,
        'status':status==''?profile['status']:status,
      }).whenComplete(() {
        Navigator.pop(context);
      });
    }).catchError((e) {
      return e;
    });

  }

}
