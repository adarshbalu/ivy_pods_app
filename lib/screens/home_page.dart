import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ivypodsapp/screens/image_upload.dart';
import 'package:ivypodsapp/widgets/image_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences prefs;
  Map<String, bool> map = {};
  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_photo_alternate),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ImageUpload();
          }));
        },
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('images').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data.documents;
              if (data.length == 0)
                return Center(
                  child: Text(
                    'No Photos Found',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              List<Widget> imageWidget = List();

              map = getValueAsMap(data);

              for (var image in data) {
                Color color = Colors.grey;

                bool liked = map[image['name']] ?? false;

                if (liked) {
                  color = Colors.red;
                  imageWidget.add(Hero(
                    tag: image['name'],
                    child: ImageCard(
                      color: color,
                      imageUrl: image['url'],
                      imageName: image['name'],
                      onTap: () {
                        changeMapValue(image['name'], false);
                        change(image['name'], false);
                        color = Colors.grey;
                      },
                    ),
                  ));
                } else {
                  color = Colors.grey;
                  imageWidget.add(Hero(
                    tag: image['name'],
                    child: ImageCard(
                      color: color,
                      imageName: image['name'],
                      imageUrl: image['url'],
                      onTap: () {
                        changeMapValue(image['name'], true);
                        change(image['name'], true);
                        color = Colors.red;
                      },
                    ),
                  ));
                }
              }

              imageWidget.add(
                Text(
                  'Made for IvyPods Internship.',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              );
              return ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 30, bottom: 20.0, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: Color(0xff041911),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                        Text(
                          'Image Gallery',
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        )),
                    child: Column(
                      children: imageWidget,
                    ),
                  ),
                ],
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }

  Map<String, bool> getValueAsMap(List list) {
    Map<String, bool> map = Map();
    for (var image in list) {
      map[image['name']] = getValue(image['name']);
    }
    return map;
  }

  change(String name, bool value) {
    prefs.setBool(name, value);
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool getValue(String name) {
    bool boolValue = prefs.getBool(name);
    return boolValue;
  }

  changeMapValue(String key, bool value) {
    setState(() {
      map[key] = value;
    });
  }
}
