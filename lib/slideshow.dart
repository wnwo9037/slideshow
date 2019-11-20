import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Slideshow extends StatefulWidget {
  final List<Image> images;

  Slideshow(this.images);

  @override
  _SlideshowState createState() => _SlideshowState(images);
}

class _SlideshowState extends State<Slideshow> {
  final List<Image> images;
  Timer timer;
  Image image1;
  Image image2;
  int i = 0;

  _SlideshowState(this.images);

  @override
  void initState() {
    super.initState();
    if (images.isEmpty) {
      return;
    }

    image1 = images[0];
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
    if (images.isEmpty) {
      return Container(
        color: Colors.cyan,
        child: Center(
          child: Container(
            child: Text('No images.'),
          ),
        ),
      );
    }

    return AnimatedCrossFade(
      crossFadeState:
          i % 2 == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: Center(child: image1),
      secondChild: Center(child: image2),
      duration: const Duration(milliseconds: 1000),
    );
  }
}
