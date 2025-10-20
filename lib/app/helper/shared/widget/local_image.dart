import 'dart:io';

import 'package:flutter/material.dart';

class LocalImageWidget extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const LocalImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    final imageFile = File(imagePath!);

    if (!imageFile.existsSync()) {
      return _buildErrorWidget();
    }

    Widget imageWidget = Image.file(
      imageFile,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: borderRadius,
          ),
          child: Icon(
            Icons.person,
            size: (width != null && height != null)
                ? (width! < height! ? width! * 0.6 : height! * 0.6)
                : 40,
            color: Colors.grey[600],
          ),
        );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: borderRadius,
          ),
          child: Icon(
            Icons.broken_image,
            size: (width != null && height != null)
                ? (width! < height! ? width! * 0.6 : height! * 0.6)
                : 40,
            color: Colors.grey[600],
          ),
        );
  }
}

class LocalProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const LocalProfileAvatar({
    super.key,
    required this.imagePath,
    this.radius = 50,
    this.onTap,
    this.showEditIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[300],
            child: ClipOval(
              child: LocalImageWidget(
                imagePath: imagePath,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: Icon(
                  Icons.person,
                  size: radius,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}