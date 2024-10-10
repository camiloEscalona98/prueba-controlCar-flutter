import 'package:controlcar/services/chat_gpt_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//https://i.pinimg.com/236x/6c/32/d5/6c32d520ac93f9442eb9fc895c9b07e1.jpg
class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  final ChatGPTService chatGPTService = ChatGPTService();

  final String imageUrl =
      'https://i.pinimg.com/474x/c8/ae/ce/c8aecefb2907d732f2c7b411008dfe73.jpg';

  final List<PageContent> pages = [
    const PageContent(
      title: 'Tu equipo',
      paragraph: 'No hay conexión ',
    ),
  ];

  int currentIndex = 0;
  bool isLoading = true; // Variable para controlar el estado de carga

  @override
  void initState() {
    super.initState();
    fetchResponse();
  }

  Future<void> fetchResponse() async {
    List<int> numeros = [1, 2, 3, 4, 5, 6]; // Cambia esto según sea necesario
    try {
      final prueba = await chatGPTService.sendPrompt(numeros);

      // Actualizar el contenido de las páginas con la respuesta
      setState(() {
        pages[0] = PageContent(
          title: 'Tu equipo',
          paragraph: prueba,
        );
        isLoading = false; // Cambiar el estado de carga a falso
      });
    } catch (e) {
      print('Error al obtener respuesta: $e');
      // Manejar el error (puedes mostrar un mensaje de error en la UI si lo deseas)
      setState(() {
        isLoading =
            false; // Cambiar el estado de carga a falso incluso si hay un error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 400, // Define una altura máxima para el contenedor
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: isLoading
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Lottie.asset(
                            'assets/img/loading_ia.json', // Ruta a tu archivo Lottie
                            width: 150, // Ancho de la animación
                            height: 150, // Altura de la animación
                            repeat: true, // Repetir la animación
                            reverse: false, // No revertir la animación
                            animate: true, // Animar la Lottie
                          ),
                        ), // Indicador de carga
                        const SizedBox(height: 20),
                      ],
                    )
                  : Scrollbar(
                      // Ajusta el padding aquí
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Espaciado adicional a la derecha
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pages[currentIndex].title,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              pages[currentIndex].paragraph,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageContent {
  final String title;
  final String paragraph;

  const PageContent({required this.title, required this.paragraph});
}
