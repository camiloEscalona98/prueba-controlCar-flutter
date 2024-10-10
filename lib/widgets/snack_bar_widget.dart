// Función global para mostrar el SnackBar
import 'package:controlcar/utils/text_formatter.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String pokemonName) {
  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    content: Text('¡Ya está! ${capitalizeFirstLetter(pokemonName)} atrapado!'),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
