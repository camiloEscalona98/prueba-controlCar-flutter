import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Lottie.asset(
          'assets/img/loading_animation.json', // Ruta a tu archivo Lottie
          width: 100, // Ancho de la animación
          height: 100, // Altura de la animación
          repeat: true, // Repetir la animación
          reverse: false, // No revertir la animación
          animate: true, // Animar la Lottie
        ),
      ),
    );
  }
}
