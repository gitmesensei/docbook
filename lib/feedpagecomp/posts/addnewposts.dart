import 'dart:io';
import 'dart:math';
import 'package:docbook/progress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  File _image=null;
  File _video=null;
  String _desc;
  String _link;
  FirebaseUser currentuser;
  final descController=TextEditingController();
  final linkController=TextEditingController();

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
  Future<void> _cropImage() async { File cropped = await ImageCropper.cropImage(
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
    _cropImage();
  }


  Future _uploadImage() async {
    if (_image != null) {
      final String randomName = Random().nextInt(10000).toString();

      final Reference storageReference = FirebaseStorage.instance
          .ref().child("post_images").child(randomName + ".jpg");

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
        elevation: 0,
        title: Text('Add New Post',style: TextStyle(color: Colors.lightBlue),),
      ),
      body:Container(
        child:ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 15,top: 15,right: 15),
                height: 50,
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
                      Text('"Read our policy before posting": Click here',style: TextStyle(color: Colors.white,fontSize: 14),),
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
                          hintText: ' type something here...',
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
                  Padding(padding: EdgeInsets.only(top: 20,left: 5),
                    child:ButtonTheme(
                      minWidth: 10,
                      height: 30,
                      child: RaisedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        label: Text("camera +",
                            style: TextStyle(color: Colors.white)),
                        icon: Icon(Icons.camera_alt,color: Colors.white,),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20,left: 10),
                    child:ButtonTheme(
                      minWidth: 10,
                      height: 30,
                      child: RaisedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Colors.lightBlue,
                        textColor: Colors.white,
                        label: Text("gallery +",
                            style: TextStyle(color: Colors.white)),
                        icon: Icon(Icons.image,color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Container(
                padding: EdgeInsets.all(20),
                  child:  Stack(
                    children: <Widget>[
                      Container(
                        child: _image==null?
                        SizedBox(height: 10,):
                        Image.file(_image,fit: BoxFit.cover,)
                      ),
                      _image!=null? Padding(
                          padding: EdgeInsets.only(top: 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(top: 20,left: 0),
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
                      ): SizedBox(width: 1,)



                    ],
                  )
              ),
            ),



          ],

        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          tooltip: 'post',
          icon: Icon(Icons.file_upload,color: Colors.white,),
          label: Text('Post'),
          onPressed: (){
            if(_desc!=null || _link!=null){
              _uploadImage();
              linkController.clear();
              descController.clear();

            }

          }),

    );
  }

  void storetoDatabase(url) {

    Firestore.instance.collection('Users').document(currentuser.uid.toString()).collection('Posts').add({
      'desc': _desc == null ? '' : _desc,
      'link': _link == null ? '' : _link,
      'image_url': url == null ? null : url,
      'user_id': currentuser.uid.toString(),
      'likes':Map(),
      'timestamp': Timestamp.now(),
    });
  }

}
