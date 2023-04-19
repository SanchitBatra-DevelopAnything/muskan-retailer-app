import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBody extends StatelessWidget {
  const ShimmerBody({Key? key, required this.height, required this.width})
      : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.white.withOpacity(0.6),
        period: const Duration(seconds: 1),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.withOpacity(0.9)),
        ));
  }
}
