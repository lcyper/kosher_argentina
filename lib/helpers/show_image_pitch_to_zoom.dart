import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

Future<void> showImagePitchToZoom(
    BuildContext context, String base64Image) async {
  // Remove data URI prefix if present
  final String cleanBase64 =
      base64Image.contains(',') ? base64Image.split(',').last : base64Image;

  final imageBytes = base64Decode(cleanBase64);

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          // Zoomable image
          PhotoView(
            imageProvider: MemoryImage(imageBytes),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
          ),

          // Close button
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
