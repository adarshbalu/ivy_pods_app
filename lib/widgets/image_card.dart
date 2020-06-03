import 'package:flutter/material.dart';
import 'package:ivypodsapp/screens/image_view.dart';

class ImageCard extends StatelessWidget {
  final imageUrl, onTap, imageName;
  final Color color;

  ImageCard({this.imageUrl, this.onTap, this.color, this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 10,
          right: MediaQuery.of(context).size.width / 10,
          top: 8,
          bottom: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 10),
          borderRadius: BorderRadius.circular(25),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ImageView(
                tag: imageName,
                url: imageUrl,
              );
            }));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    imageUrl,
                  ),
                )),
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 14,
                  top: 14,
                  child: GestureDetector(
                    onTap: onTap,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.favorite,
                        color: color,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 3.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
