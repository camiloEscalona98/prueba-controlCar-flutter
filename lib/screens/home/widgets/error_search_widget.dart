import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorSearch extends StatelessWidget {
  const ErrorSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 8),
            Lottie.asset(
              'assets/img/no_pokemon.json', // Ruta a tu archivo Lottie
              width: 300, // Ancho de la animación
              height: 300, // Altura de la animación
              repeat: true, // Repetir la animación
              reverse: false, // No revertir la animación
              animate: true, // Animar la Lottie
            ),
            const SizedBox(height: 16),
            const Text(
              'No encontramos el Pokémon que buscas.',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
