import 'package:controlcar/models/pokemon_model.dart';
import 'package:controlcar/screens/review/review.dart';
import 'package:controlcar/utils/text_formatter.dart';
import 'package:flutter/material.dart';

class BottomModalTeam extends StatefulWidget {
  final List<Pokemon> capturedPokemons;

  const BottomModalTeam({super.key, required this.capturedPokemons});

  @override
  // ignore: library_private_types_in_public_api
  _BottomModalTeamState createState() => _BottomModalTeamState();
}

class _BottomModalTeamState extends State<BottomModalTeam> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int maxSquares = 6;
    List<Widget> squares = List.generate(maxSquares, (index) {
      // Si hay pokemon, muestra su imagen
      if (index < widget.capturedPokemons.length) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Column(
              children: [
                Image.network(
                  widget.capturedPokemons[index].imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/img/pokeball.png',
                      fit: BoxFit.cover,
                      height: 100,
                    );
                  },
                ),
                Text(capitalizeFirstLetter(widget.capturedPokemons[index].name),
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.black,
          child: Center(
            child: Image.asset(
              'assets/img/pokeball.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
        );
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: squares,
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Acción del botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Review()),
                );
              },
              child: const Text('Evalúa tu equipo con IA'),
            ),
          ),
        ],
      ),
    );
  }
}
