import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:slideshow/slideshow.dart';

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class Options {
  int duration = 5;
  bool shuffle = false;
}

class _ImagePickerState extends State<ImagePicker> {
  List<Image> images = [];
  Options options = Options();

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
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Container(
        margin: EdgeInsets.all(30.0),
        child: Column(
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
                  MaterialPageRoute(
                      builder: (context) => Slideshow(images, options)),
                );
              },
            ),
            Text('재생 시간'),
            DropdownButton<int>(
              value: options.duration,
              items: List.generate(100, (i) => i + 1)
                  .map<DropdownMenuItem<int>>((i) => DropdownMenuItem<int>(
                      value: i, child: Text(i.toString() + '초')))
                  .toList(),
              onChanged: (i) => setState(() {
                options.duration = i;
              }),
            ),
            Text('랜덤 재생'),
            Checkbox(
              value: options.shuffle,
              onChanged: (b) => setState(() {
                options.shuffle = b;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
