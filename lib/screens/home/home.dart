import 'package:controlcar/models/pokemon_model.dart';
import 'package:controlcar/screens/home/widgets/body_widget.dart';
import 'package:controlcar/services/pokemons_service.dart';

import 'package:flutter/material.dart';

import '../../utils/loading_animation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    futurePokemons = PokemonsService().fetchPokemons(20, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PokeApi")),
      body: FutureBuilder<List<Pokemon>>(
        future: futurePokemons,
        builder: (context, snapshot) {
          /*   if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingAnimation());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } */

          return const Body();
        },
      ),
    );
  }
}
