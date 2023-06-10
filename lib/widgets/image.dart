import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:may_be_clean/consts/consts.dart';

import 'dart:io';

class RoundedImage extends StatelessWidget {
  final String imageUrl;
  final double diameter;
  final bool disableMargin;
  final Function()? onTap;
  final Function()? dismissFunction;

  const RoundedImage(
      {required this.imageUrl,
      this.disableMargin = false,
      this.diameter = 100,
      this.onTap,
      this.dismissFunction,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (imageUrl == '') {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: diameter,
          height: diameter,
          margin: (disableMargin) ? null : const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorSystem.gray3),
          child: const Icon(Icons.camera_alt, color: ColorSystem.primary),
        ),
      );
    }
    if (imageUrl.startsWith('http')) {
      return GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          cacheKey: imageUrl,
          width: diameter,
          memCacheWidth: diameter.toInt(),
          maxWidthDiskCache: diameter.toInt(),
          imageBuilder: (context, imageProvider) => Container(
            width: diameter,
            height: diameter,
            margin: (disableMargin) ? null : const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            width: diameter,
            height: diameter,
            margin: (disableMargin) ? null : const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            width: diameter,
            height: diameter,
            margin: (disableMargin) ? null : const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorSystem.gray2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.error),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: diameter,
            height: diameter,
            margin: (disableMargin) ? null : const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: FileImage(File(imageUrl)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (dismissFunction != null)
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: dismissFunction,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorSystem.primary,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
