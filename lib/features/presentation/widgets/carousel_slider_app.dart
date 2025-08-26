import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class CarouselSliderApp extends StatefulWidget {
  List<String> images;
  CarouselSliderApp({super.key, required this.images});

  @override
  State<CarouselSliderApp> createState() => _CarouselSliderAppState();
}

class _CarouselSliderAppState extends State<CarouselSliderApp> {
  int sliderindex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        carousel_slider.CarouselSlider(
          items: List.generate(
              widget.images.length,
              (index) => Image.network(
                    key: ValueKey(index),
                    widget.images[index],
                    // fit: BoxFit.cover,
                  )),
          // carouselController: _CarouselController,
          options: carousel_slider.CarouselOptions(
            height: 140,
            viewportFraction: 0.7,
            initialPage: 0,
            enableInfiniteScroll: true,
            onPageChanged: (index, reason) {
              // print(index);
              // context.read<StreamsetectCubit>(). .emit(StreamsetectInitial());
              safeSetState(() {
                sliderindex = index;
              });
            },
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Center(
              child: SizedBox(
                height: 15,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    key: ValueKey(index),
                    width: index == sliderindex ? 30 : 10,
                    height: 10,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: sliderindex == index
                          ? ColorResources.buttoncolor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
