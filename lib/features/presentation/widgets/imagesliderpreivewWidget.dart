// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class ImageSlidePreviewWidget extends StatefulWidget {
  final List<String> images;
  final bool isImageindex;
  const ImageSlidePreviewWidget({super.key, required this.images, required this.isImageindex});

  @override
  State<ImageSlidePreviewWidget> createState() => _ImageSlidePreviewWidgetState();
}

class _ImageSlidePreviewWidgetState extends State<ImageSlidePreviewWidget> {
  String selectimage = '';
  TransformationController controllerimage = TransformationController();
  carousel_slider.CarouselSliderController carouselController = carousel_slider.CarouselSliderController();
  Matrix4? initialControllerValue;
  @override
  void initState() {
    super.initState();
    selectimage = widget.images.isEmpty ? '' : widget.images.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ColorResources.borderColor,
            ),
            color: Colors.white,
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                useSafeArea: true,
                builder: (context) => Dialog(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close)),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: widget.images
                                  .map((e) => CachedNetworkImage(
                                      placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageUrl: e))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                context: context,
              );
            },
            child: carousel_slider.CarouselSlider(
              carouselController: carouselController,
              options: carousel_slider.CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  safeSetState(() {
                    selectimage = widget.images[index];
                  });
                },
              ),
              items: widget.images
                  .map(
                    (e) => CachedNetworkImage(
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      imageUrl: e,
                      width: double.infinity,
                      // fit: BoxFit.fitHeight,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        widget.isImageindex
            ? Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemCount: widget.images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      safeSetState(() {
                        controllerimage.value = Matrix4(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
                        selectimage = widget.images[index];
                        carouselController.animateToPage(index);
                      });
                    },
                    child: CachedNetworkImage(
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      imageUrl: widget.images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ))
            : SizedBox(
                height: 10,
                child: Center(
                  child: ListView.builder(
                      itemCount: widget.images.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            carouselController.animateToPage(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOutCubicEmphasized,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 10,
                            width: widget.images[index] == selectimage ? 20 : 10,
                            decoration: BoxDecoration(
                              color: widget.images[index] == selectimage ? ColorResources.buttoncolor : Colors.black,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        );
                      }),
                ),
              ),
      ],
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> body;
  final IconData openIcon;
  final IconData closeIcon;
  final Color backgroundColor;
  final Color collapsedBackgroundColor;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.body,
    required this.openIcon,
    required this.closeIcon,
    this.backgroundColor = Colors.white,
    this.collapsedBackgroundColor = Colors.white,
  });

  @override
  MyExpansionTileState createState() => MyExpansionTileState();
}

class MyExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: widget.backgroundColor,
        // tilePadding: EdgeInsets.zero,
        collapsedBackgroundColor: widget.collapsedBackgroundColor,
        title: Text(
          widget.title,
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 0,
          ),
        ),
        trailing: Icon(
          isExpanded ? widget.openIcon : widget.closeIcon,
        ),
        onExpansionChanged: (expanded) {
          safeSetState(() {
            isExpanded = expanded;
          });
        },
        children: widget.body,
      ),
    );
  }
}
