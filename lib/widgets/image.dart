import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:may_be_clean/consts/consts.dart';

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final double diameter;

  const RoundedImage({required this.imageUrl, this.diameter = 100, super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: imageUrl,
      width: diameter,
      memCacheWidth: diameter.toInt(),
      maxWidthDiskCache: diameter.toInt(),
      imageBuilder: (context, imageProvider) => Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: ColorSystem.gray2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.error),
      ),
    );
  }
}
