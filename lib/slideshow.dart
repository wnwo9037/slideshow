import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'image_picker.dart';

class Slideshow extends StatefulWidget {
  final List<Image> images;
  final Options options;

  Slideshow(this.images, this.options);

  @override
  _SlideshowState createState() => _SlideshowState(images, options);
}

class _SlideshowState extends State<Slideshow> {
  final List<Image> images;
  final Options option;

  Timer timer;
  Image image1;
  Image image2;
  int i = 0;

  _SlideshowState(this.images, this.option);

  @override
  void initState() {
    super.initState();
    if (images.isEmpty) {
      return;
    }

    if (option.shuffle) {
      images.shuffle();
    }

    image1 = images[0];
    timer = Timer.periodic(Duration(seconds: option.duration), (timer) {
      setState(() {
        i = i + 1;
        if (i % 2 == 0) {
          image1 = images[i % images.length];
        } else {
          image2 = images[i % images.length];
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          i % 2 == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Center(child: image1),
      secondChild: Center(child: image2),
      duration: const Duration(milliseconds: 1000),
    );
  }
}
