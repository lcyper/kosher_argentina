import 'dart:convert';

import 'package:flutter/material.dart';

Widget buildBase64Image(String base64String) {
  // Remove data URI prefix if present (common in web/base64 strings)
  final String base64Data =
      base64String.contains(',') ? base64String.split(',').last : base64String;

  return Image.memory(
    base64Decode(base64Data),
    fit: BoxFit.cover, // or any other BoxFit value
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.error); // Fallback widget if image fails to load
    },
  );
}