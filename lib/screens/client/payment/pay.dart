import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_view/photo_view.dart';

class viewinsurencephoto extends StatelessWidget {
  const viewinsurencephoto({Key? key, required this.photourl})
      : super(key: key);
  final photourl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          PhotoView(
            imageProvider: NetworkImage(photourl),
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
