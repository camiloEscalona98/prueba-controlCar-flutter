import 'dart:convert';

import 'package:controlcar/models/pokemon_model.dart';
import 'package:controlcar/screens/home/widgets/error_search_widget.dart';
import 'package:controlcar/screens/home/widgets/header_widget.dart';

import 'package:controlcar/screens/home/widgets/list_item_widget.dart';
import 'package:controlcar/services/pokemons_service.dart';
import 'package:controlcar/utils/loading_animation.dart';
import 'package:controlcar/utils/text_formatter.dart';

import 'package:controlcar/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Pokemon> pokemons = [];
  List<Pokemon> capturedPokemons = [];
  Pokemon? searchedPokemon;
  int currentPage = 0;
  final int itemsPerPage = 30;
  bool isLoading = false;
  bool hasError = false;
  bool isModalActive = false;
  bool pokemonNotAllowed = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCapturedPokemons();
    _fetchPokemonData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Método para buscar Pokémon por nombre usando la API
  Future<void> _searchPokemonByName() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        searchedPokemon = null;
        currentPage = 0;
      });
      _fetchPokemonData();
      return;
    }

    setState(() {
      isLoading = true;
      hasError = false;
      searchedPokemon = null;
    });

    try {
      final pokemon =
          await PokemonsService().fetchPokemonByName(query.toLowerCase());

      if (pokemon != null) {
        if (pokemon.id > 150) {
          // Si el ID del Pokémon es mayor a 150, mostrar la imagen de advertencia
          // ignore: use_build_context_synchronously
          showSnackBar(
            context,
            Colors.red[300]!,
            Text(
                '${capitalizeFirstLetter(pokemon.name)} no corresponde a la primera generación'),
          );
          setState(() {
            searchedPokemon = null;
            hasError = false;
            pokemonNotAllowed = true;
          });
        } else {
          // Si el Pokémon es válido (id <= 150)
          setState(() {
            searchedPokemon = pokemon;
            pokemonNotAllowed = false; // No mostrar la advertencia
          });
        }
      } else {
        setState(() {
          hasError = true;
          pokemonNotAllowed = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        pokemonNotAllowed = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    if (newPage > 5) {
      return;
    }
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
        showSnackBar(
          context,
          Colors.green[300]!,
          Text('¡Ya está! ${capitalizeFirstLetter(pokemon.name)} atrapado!'),
        );
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

              // Header con el input de búsqueda
              if (!isLoading)
                Header(
                  searchController: searchController,
                  capturedPokemons: capturedPokemons,
                  onSearch: _searchPokemonByName,
                ),

              if (!isLoading && !hasError) ...[
                const SizedBox(height: 20),

                // Si hay un resultado de búsqueda o todos los pokemones
                Expanded(
                  child: searchedPokemon != null
                      ? GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            GestureDetector(
                              onTap: () => addPokemon(searchedPokemon!),
                              child: PokemonListItem(
                                isCaptured: capturedPokemons
                                    .any((p) => p.id == searchedPokemon!.id),
                                pokemonName: searchedPokemon!.name,
                                pokemonTypes: searchedPokemon!.types
                                    .map((type) => type.name)
                                    .toList(),
                                pokemonNumber: searchedPokemon!.id.toString(),
                                pokemonImageUrl: searchedPokemon!.imageUrl,
                              ),
                            ),
                          ],
                        )
                      : GridView.count(
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
                                pokemonTypes: pokemon.types
                                    .map((type) => type.name)
                                    .toList(),
                                pokemonNumber: pokemon.id.toString(),
                                pokemonImageUrl: pokemon.imageUrl,
                              ),
                            );
                          }),
                        ),
                ),
                const SizedBox(height: 16),
              ],

              // Mostrar una imagen cuando hay un error
              if (hasError && !isLoading) ErrorSearch(),
            ],
          ),
        ),

        // Botones flotantes para cambiar de página
        if (!isLoading && searchedPokemon == null && !hasError) ...[
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.extended(
              onPressed:
                  currentPage > 0 ? () => _changePage(currentPage - 1) : null,
              backgroundColor: Colors.transparent,
              elevation: 0,
              label:
                  const Text("Anterior", style: TextStyle(color: Colors.black)),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: currentPage < 4
                  ? () => _changePage(currentPage + 1)
                  : null, // Si currentPage es 5 o mayor, el botón no hace nada
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
          ),
        ],
      ],
    );
  }
}
