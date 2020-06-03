import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File imageFile;
  final picker = ImagePicker();
  String imageUrl, userId;
  bool uploading = false;
  Future getImage(String type) async {
    var pickedFile;
    if (type == 'camera')
      pickedFile = await picker.getImage(source: ImageSource.camera);
    else
      pickedFile = await picker.getImage(source: ImageSource.gallery);

    imageFile = File(pickedFile.path);

    await uploadFile(basename(imageFile.path));
  }

  getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
  }

  Future uploadFile(String name) async {
    setState(() {
      uploading = true;
    });
    String fileName = name;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      var documentReference =
          Firestore.instance.collection('images').document(basename(name));

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'likedUsers': [],
            'likes': 0,
            'url': imageUrl,
            'name': fileName,
          },
        );
      });
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff041911),
      ),
      backgroundColor: Color(0xff041911),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Upload Image',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                padding: EdgeInsets.only(
                    top: 10, bottom: MediaQuery.of(context).size.height / 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    )),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/cam.png',
                      height: 200,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton.icon(
                          icon: Icon(Icons.camera_alt),
                          textColor: Colors.white,
                          color: Colors.indigo,
                          onPressed: () async {
                            await getImage('camera');
                            Navigator.pop(context);
                          },
                          animationDuration: Duration(seconds: 5),
                          label: Text('Camera'),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        RaisedButton.icon(
                          icon: Icon(Icons.image),
                          textColor: Colors.white,
                          color: Colors.indigo,
                          onPressed: () async {
                            await getImage('gallery');
                            Navigator.pop(context);
                          },
                          label: Text('Gallery'),
                        ),
                      ],
                    ),
                    uploading
                        ? Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Image Uploading'),
                              ),
                              CircularProgressIndicator(),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
