// Función global para mostrar el SnackBar
import 'package:controlcar/utils/text_formatter.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, Color color, Text text) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: text,
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
