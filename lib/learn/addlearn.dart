import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';

class AddLearn extends StatefulWidget {
  @override
  _AdPostState createState() => _AdPostState();
}

class _AdPostState extends State<AddLearn> {

  File _image=null;
  String _desc;
  String _link;
  FirebaseUser currentuser;
  final descController=TextEditingController();
  final linkController=TextEditingController();



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
          CropAspectRatioPreset.ratio4x3,
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
  }

  Future _uploadImage() async {
    if (_image != null) {
      final String randomName = Random().nextInt(10000).toString();

      final Reference storageReference = FirebaseStorage.instance
          .ref().child("news_images").child(randomName + ".jpg");

      final UploadTask uploadTask = storageReference.putFile(
          _image);

      TaskSnapshot durl = await uploadTask;

      String url = await durl.ref.getDownloadURL();

      storetoDatabase(url);
    }else{

      storetoDatabase(null);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.lightBlue),
        title: Text('add learn',style: TextStyle(color: Colors.lightBlue),),
      ),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image_01.png'), fit: BoxFit.fill),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child:ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 15,top: 15,right: 15),
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Hot News!',style: TextStyle(color: Colors.white,fontSize: 28),),
                      Text('"post pic with compulsory link"',style: TextStyle(color: Colors.white,fontSize: 14),),
                    ],
                  ),
                )
            ),
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 20,left: 10,right:10 ),
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                          color: Colors.lightBlue, width: 2)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child:TextField(
                        maxLines: 5,
                        controller: descController,
                        onChanged: (value) {

                          _desc=value;
                        },
                        decoration: InputDecoration(
                          hintText: ' keep it short',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )

              ),
            ),

            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 10,left: 10,right:10 ),
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                          color: Colors.lightBlue, width: 2)),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child:TextField(
                        maxLines: 5,
                        controller: linkController,
                        onChanged: (value) {

                          _link=value;

                        },
                        decoration: InputDecoration(
                          hintText: ' you can also add link',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )

              ),
            ),

            Center(
              child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child:ButtonTheme(
                    minWidth: 10,
                    height: 30,
                    child: RaisedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 6.0),
                        child: Text("camera +",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20,left: 20),
                  child:ButtonTheme(
                    minWidth: 10,
                    height: 30,
                    child: RaisedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.lightBlue,
                      textColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.0, vertical: 6.0),
                        child: Text("gallery +",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Container(
                    margin: EdgeInsets.only(left: 15,top: 15,right: 15),
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child:  Stack(
                      children: <Widget>[

                        Container(
                          child: _image==null?
                              Center(child: Icon(Icons.add_a_photo,color: Colors.grey,size: 120,)):
                          ListView(
                            shrinkWrap: true,
                            primary: false,
                            children: <Widget>[
                            Image.file(_image,fit: BoxFit.cover,)
                          ],)
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 60,top: 220),
                            child: Row(
                          children: <Widget>[

                            Padding(padding: EdgeInsets.only(top: 20,left: 20),
                              child:ButtonTheme(
                                minWidth: 10,
                                height: 30,
                                child: RaisedButton(
                                  onPressed: () => _cropImage(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)),
                                  color: Colors.lightBlue,
                                  textColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 6.0),
                                    child: Text("crop",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 20,left: 20),
                              child:ButtonTheme(
                                minWidth: 10,
                                height: 30,
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      _image=null;
                                      _cropImage()==null;

                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0)),
                                  color: Colors.pinkAccent,
                                  textColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 6.0),
                                    child: Text("cancel x",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        )



                      ],
                    )
                  ),
            ),



          ],

        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'post',
          child: Icon(Icons.file_upload,color: Colors.white,),
          onPressed: (){

            _uploadImage();
              linkController.clear();
              descController.clear();
          }),

    );
  }

  void storetoDatabase(url) {

    Firestore.instance.collection('Learn').add({
      'desc': _desc == null ? '' : _desc,
      'link': _link == null ? '' : _link,
      'image_url': url == null ? null : url,
      'user_id': currentuser.uid.toString(),
      'timestamp': Timestamp.now()
    });
  }
}
