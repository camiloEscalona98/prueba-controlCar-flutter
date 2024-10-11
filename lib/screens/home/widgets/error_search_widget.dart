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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(
                'assets/img/no_pokemon.json',
                width: 300,
                height: 300,
                repeat: true,
                reverse: false,
                animate: true,
              ),
              const SizedBox(height: 16),
              const Text(
                'No encontramos el Pokémon que buscas.',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }
}
