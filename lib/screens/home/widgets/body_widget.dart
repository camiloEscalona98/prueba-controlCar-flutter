import 'dart:convert';

import 'package:controlcar/models/pokemon_model.dart';
import 'package:controlcar/screens/home/widgets/bottom_modal_team_widget.dart';
import 'package:controlcar/screens/home/widgets/header_widget.dart';

import 'package:controlcar/screens/home/widgets/list_item_widget.dart';
import 'package:controlcar/services/pokemons_service.dart';
import 'package:controlcar/utils/loading_animation.dart';

import 'package:controlcar/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Pokemon> pokemons = [];
  List<Pokemon> capturedPokemons = [];
  int currentPage = 0;
  final int itemsPerPage = 20;
  bool isLoading = false;
  bool hasError = false;
  bool isModalActive = false;
  TextEditingController searchController = TextEditingController();
  final PokemonsService _pokemonService = PokemonsService();

  @override
  void initState() {
    super.initState();
    _loadCapturedPokemons();
    _fetchPokemonData();
  }

  // Metodo para cargar datos de la API según la página
  Future<void> _fetchPokemonData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final newPokemons = await PokemonsService()
          .fetchPokemons(itemsPerPage, currentPage * itemsPerPage);
      setState(() {
        pokemons = newPokemons;
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Metodo para cambiar de página
  void _changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
    // Cargar la nueva página
    _fetchPokemonData();
  }

  // Cargar pokemons capturados desde SharedPreferences
  Future<void> _loadCapturedPokemons() async {
    final prefs = await SharedPreferences.getInstance();

    final savedPokemonsJson = prefs.getStringList('capturedPokemons') ?? [];

    // Inicializa la lista de Pokémon capturados
    List<Pokemon> loadedPokemons = [];

    // Itera sobre cada JSON almacenado
    for (String pokemonJson in savedPokemonsJson) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(pokemonJson);
        // Convierte el JSON a un objeto Pokemon
        loadedPokemons.add(Pokemon.fromJson(jsonMap));
      } catch (e) {
        // Imprime el error para ayudar a depurar
        print('Error al deserializar Pokémon: $pokemonJson');
        print(e);
      }
    }

    // Actualiza el estado una vez que todos los Pokémon han sido cargados
    setState(() {
      capturedPokemons = loadedPokemons;
    });
  }

  // Metodo para guardar pokemones capturados en sharedPreference
  Future<void> _saveCapturedPokemons() async {
    final prefs = await SharedPreferences.getInstance();
    final pokemonsJson = capturedPokemons
        .map((pokemon) => json.encode(pokemon.toJson()))
        .toList();

    await prefs.setStringList('capturedPokemons', pokemonsJson);
  }

// Método para guardar un Pokémon
  void addPokemon(Pokemon pokemon) {
    setState(() {
      // Si el Pokémon ya está capturado, se elimina
      if (capturedPokemons.any((p) => p.id == pokemon.id)) {
        capturedPokemons.removeWhere((p) => p.id == pokemon.id);
      } else {
        // Si la lista ya tiene 6 Pokémon, se elimina el último antes de agregar el nuevo
        if (capturedPokemons.length >= 6) {
          capturedPokemons.removeAt(0); // Eliminar el último elemento
        }
        // Añadir el Pokémon capturado al inicio
        capturedPokemons.insert(0, pokemon);
        // Mostrar Snackbar con el nombre del Pokémon capturado
        showSnackBar(context, pokemon.name);
      }
      _saveCapturedPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (isLoading) const Expanded(child: LoadingAnimation()),
              if (hasError) const Text('Error al cargar los datos.'),
              if (!isLoading)
                Header(
                  searchController: searchController,
                  capturedPokemons: capturedPokemons,
                  onChanged: () {},
                ),
              if (!isLoading && !hasError) ...[
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: List.generate(pokemons.length, (index) {
                      final pokemon = pokemons[index];
                      final isCaptured =
                          capturedPokemons.any((p) => p.id == pokemon.id);

                      return GestureDetector(
                        onTap: () => addPokemon(pokemon),
                        child: PokemonListItem(
                          isCaptured: isCaptured,
                          pokemonName: pokemon.name,
                          pokemonTypes:
                              pokemon.types.map((type) => type.name).toList(),
                          pokemonNumber: pokemon.id.toString(),
                          pokemonImageUrl: pokemon.imageUrl,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        // Botones flotantes para navegación
        !isLoading
            ? Positioned(
                bottom: 16,
                left: 16,
                child: FloatingActionButton.extended(
                  onPressed: currentPage > 0
                      ? () => _changePage(currentPage - 1)
                      : null,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  label: const Text("Anterior",
                      style: TextStyle(color: Colors.black)),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              )
            : const SizedBox.shrink(),
        !isLoading
            ? Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: () => _changePage(currentPage + 1),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Siguiente", style: TextStyle(color: Colors.black)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.black),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
