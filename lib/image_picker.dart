import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:slideshow/slideshow.dart';

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  List<Image> images = [];

  getGalleryImages() async {
    try {
      var images = await Future.wait(
          (await MultiImagePicker.pickImages(maxImages: 1000))
              .map((asset) async => Image.file(File(await asset.filePath))));

      setState(() {
        this.images = images;
      });
    } catch (NoImagesSelectedException) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            color: Colors.cyan[100],
            child: Text('이미지 선택: ${images.length}'),
            onPressed: () {
              getGalleryImages();
            },
          ),
          FlatButton(
            color: Colors.cyan[100],
            child: Text('슬라이드쇼 시작'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Slideshow(images)),
              );
            },
          )
        ],
      ),
    );
  }
}
