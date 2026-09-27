import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? radius;

  bool get _isRemote => url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: AppColors.brand100,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: AppColors.brand600),
    );

    final image = url.isEmpty
        ? placeholder
        : _isRemote
        ? Image.network(
            url,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) => placeholder,
          )
        : Image.file(
            File(url),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) => placeholder,
          );

    if (radius == null) return image;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!),
      child: image,
    );
  }
}
