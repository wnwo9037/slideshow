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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.cyan[100],
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: images
                    .map((image) => Image(
                          image: image.image,
                          filterQuality: FilterQuality.low,
                        ))
                    .toList()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.cyan[100],
                  size: 100,
                ),
                onPressed: () {
                  getGalleryImages();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.play_circle_filled,
                  size: 100,
                  color: Colors.cyan[100],
                ),
                onPressed: () {
                  if (images.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Slideshow(images, options)),
                    );
                  }
                },
              ),
            ],
          ),
          Container(
            height: 50,
            color: Colors.cyan[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.cyan,
                    size: 50,
                  ),
                  onPressed: () => setState(() {
                    if (options.duration > 1) {
                      options.duration--;
                    }
                  }),
                ),
                Text(
                  '${options.duration}s',
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 20.0,
                  ),
                ),
                FlatButton(
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 50,
                    color: Colors.cyan,
                  ),
                  onPressed: () => setState(() {
                    options.duration++;
                  }),
                ),
                FlatButton(
                  child: options.shuffle
                      ? Icon(
                          Icons.shuffle,
                          size: 30,
                          color: Colors.cyan,
                        )
                      : Icon(
                          Icons.repeat,
                          size: 30,
                          color: Colors.cyan,
                        ),
                  onPressed: () => setState(() {
                    options.shuffle = !options.shuffle;
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
