import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DisplayImageFullScreen extends StatefulWidget {

  final List<String> images;
  final String clickedImage;
  const DisplayImageFullScreen({required this.images, required this.clickedImage, Key? key}):super(key: key);

  @override
  State<DisplayImageFullScreen> createState() => _DisplayImageFullScreenState();
}

class _DisplayImageFullScreenState extends State<DisplayImageFullScreen> {

  CarouselController carouselController = CarouselController();

  List<String> myImages = [];

  @override
  void initState() {
    myImages.add(widget.clickedImage);
    myImages.addAll(widget.images);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: CarouselSlider(
            items: myImages.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Center(
                    child: Hero(
                      tag: 'enlargeImage',
                      child: Image.network(
                          i
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            carouselController: carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              aspectRatio: 1 / 1,
              viewportFraction: 1,
              initialPage: 0,
              reverse: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            )),
      ),
    );
  }
}


class DisplayVideoFullScreen extends StatefulWidget {

  final String selfieVideo;
  final String workVideo;
  final String type;
  const DisplayVideoFullScreen({required this.selfieVideo, required this.workVideo, required this.type, Key? key}):super(key: key);

  @override
  State<DisplayVideoFullScreen> createState() => _DisplayVideoFullScreenState();
}

class _DisplayVideoFullScreenState extends State<DisplayVideoFullScreen> {

  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: CarouselSlider(
          items: widget.type=="main"?[widget.workVideo, widget.selfieVideo].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Hero(
                  tag:"enlargeImage",
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              },
            );
          }).toList():[widget.selfieVideo, widget.workVideo].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Hero(
                  tag:"enlargeImage",
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              },
            );
          }).toList(),
          carouselController: carouselController,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            aspectRatio: 1 / 1,
            viewportFraction: 1,
            initialPage: 0,
            reverse: false,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}