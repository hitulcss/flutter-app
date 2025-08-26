import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCustom extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  ShimmerCustom.rectangular(
      {super.key, this.width = double.infinity, required this.height})
      : shapeBorder =
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));

  const ShimmerCustom.circular(
      {super.key, this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[200]!,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: shapeBorder,
          ),
        ),
      );
}
