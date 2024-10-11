import 'dart:convert';

import 'package:controlcar/global/pokemon_types.dart';
import 'package:controlcar/models/pokemon_model.dart';
import 'package:controlcar/screens/home/widgets/error_search_widget.dart';
import 'package:controlcar/screens/home/widgets/header_widget.dart';

import 'package:controlcar/screens/home/widgets/list_item_widget.dart';
import 'package:controlcar/services/pokemon_manager.dart';
import 'package:controlcar/services/pokemons_service.dart';
import 'package:controlcar/utils/loading_animation.dart';
import 'package:controlcar/utils/text_formatter.dart';

import 'package:controlcar/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final PokemonManager pokemonManager = PokemonManager();

  @override
  void initState() {
    super.initState();
    _loadCapturedPokemons();
    _fetchPokemonData();
  }

  @override
  void dispose() {
    pokemonManager.searchController.dispose();
    super.dispose();
  }

  // Método para buscar Pokémon por nombre o tipo
  Future<void> _searchPokemon() async {
    final query = pokemonManager.searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() {
        pokemonManager.searchedPokemon = null;
        pokemonManager.currentPage = 0;
      });
      _fetchPokemonData();
      return;
    }

    setState(() {
      pokemonManager.isLoading = true;
      pokemonManager.hasError = false;
      pokemonManager.searchedPokemon = null;
    });

    try {
      if (pokemonTypes.contains(query)) {
        final newPokemons = await PokemonsService().searchPokemonByType(query);
        setState(() {
          pokemonManager.pokemons = newPokemons;

          pokemonManager.currentPage = 0;
        });
      } else {
        await _searchPokemonByName();
      }
    } catch (e) {
      setState(() {
        pokemonManager.hasError = true;
        pokemonManager.pokemonNotAllowed = false;
      });
    } finally {
      setState(() {
        pokemonManager.isLoading = false;
      });
    }
  }

  // Método para buscar Pokémon por nombre usando la API
  Future<void> _searchPokemonByName() async {
    final query = pokemonManager.searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        pokemonManager.searchedPokemon = null;
        pokemonManager.currentPage = 0;
      });
      _fetchPokemonData();
      return;
    }

    setState(() {
      pokemonManager.isLoading = true;
      pokemonManager.hasError = false;
      pokemonManager.searchedPokemon = null;
    });

    try {
      final pokemon =
          await PokemonsService().fetchPokemonByName(query.toLowerCase());

      if (pokemon != null) {
        if (pokemon.id > 150) {
          // ignore: use_build_context_synchronously
          showSnackBar(
            context,
            Colors.red[300]!,
            Text(
                '${capitalizeFirstLetter(pokemon.name)} no corresponde a la primera generación'),
          );
          setState(() {
            pokemonManager.searchedPokemon = null;
            pokemonManager.hasError = false;
            pokemonManager.pokemonNotAllowed = true;
          });
        } else {
          setState(() {
            pokemonManager.searchedPokemon = pokemon;
            pokemonManager.pokemonNotAllowed = false;
          });
        }
      } else {
        setState(() {
          pokemonManager.hasError = true;
          pokemonManager.pokemonNotAllowed = false;
        });
      }
    } catch (e) {
      setState(() {
        pokemonManager.hasError = true;
        pokemonManager.pokemonNotAllowed = false;
      });
    } finally {
      setState(() {
        pokemonManager.isLoading = false;
      });
    }
  }

  // Método para cargar datos de la API según la página
  Future<void> _fetchPokemonData() async {
    setState(() {
      pokemonManager.isLoading = true;
      pokemonManager.hasError = false;
    });

    try {
      final newPokemons = await PokemonsService().fetchPokemons(
          pokemonManager.itemsPerPage,
          pokemonManager.currentPage * pokemonManager.itemsPerPage);
      setState(() {
        pokemonManager.pokemons = newPokemons;
      });
    } catch (e) {
      setState(() {
        pokemonManager.hasError = true;
      });
    } finally {
      setState(() {
        pokemonManager.isLoading = false;
      });
    }
  }

  // Método para cambiar de página
  void _changePage(int newPage) {
    if (newPage > 5) {
      return;
    }
    setState(() {
      pokemonManager.currentPage = newPage;
    });
    // Cargar la nueva página
    _fetchPokemonData();
  }

  // Cargar pokémons capturados desde SharedPreferences
  Future<void> _loadCapturedPokemons() async {
    final prefs = await SharedPreferences.getInstance();

    final savedPokemonsJson = prefs.getStringList('capturedPokemons') ?? [];

    // Inicializa la lista de Pokémon capturados
    List<Pokemon> loadedPokemons = [];

    // Itera sobre cada JSON almacenado
    for (String pokemonJson in savedPokemonsJson) {
      try {
        final Map<String, dynamic> jsonMap = json.decode(pokemonJson);
        // Convierte el JSON a un objeto Pokémon
        loadedPokemons.add(Pokemon.fromJson(jsonMap));
        // ignore: empty_catches
      } catch (e) {}
    }

    // Actualiza el estado una vez que todos los Pokémon han sido cargados
    setState(() {
      pokemonManager.capturedPokemons = loadedPokemons;
    });
  }

  // Método para guardar pokémons capturados en SharedPreferences
  Future<void> _saveCapturedPokemons() async {
    final prefs = await SharedPreferences.getInstance();
    final pokemonsJson = pokemonManager.capturedPokemons
        .map((pokemon) => json.encode(pokemon.toJson()))
        .toList();

    await prefs.setStringList('capturedPokemons', pokemonsJson);
  }

  // Método para guardar un Pokémon
  void addPokemon(Pokemon pokemon) {
    setState(() {
      if (pokemonManager.capturedPokemons.any((p) => p.id == pokemon.id)) {
        pokemonManager.capturedPokemons.removeWhere((p) => p.id == pokemon.id);
      } else {
        if (pokemonManager.capturedPokemons.length >= 6) {
          pokemonManager.capturedPokemons.removeAt(0);
        }

        pokemonManager.capturedPokemons.insert(0, pokemon);

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
    final isSearchingByType = pokemonManager.searchController.text.isNotEmpty &&
        pokemonTypes.contains(
            pokemonManager.searchController.text.trim().toLowerCase());

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              if (pokemonManager.isLoading)
                const Expanded(child: LoadingAnimation()),

              // Header con el input de búsqueda
              if (!pokemonManager.isLoading)
                Header(
                  searchController: pokemonManager.searchController,
                  capturedPokemons: pokemonManager.capturedPokemons,
                  onSearch: _searchPokemon,
                ),

              if (!pokemonManager.isLoading && !pokemonManager.hasError) ...[
                const SizedBox(height: 20),

                // Si hay un resultado de búsqueda o todos los Pokémon
                Expanded(
                  child: pokemonManager.searchedPokemon != null
                      ? GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  addPokemon(pokemonManager.searchedPokemon!),
                              child: PokemonListItem(
                                isCaptured: pokemonManager.capturedPokemons.any(
                                    (p) =>
                                        p.id ==
                                        pokemonManager.searchedPokemon!.id),
                                pokemonName:
                                    pokemonManager.searchedPokemon!.name,
                                pokemonTypes: pokemonManager
                                    .searchedPokemon!.types
                                    .map((type) => type.name)
                                    .toList(),
                                pokemonNumber: pokemonManager
                                    .searchedPokemon!.id
                                    .toString(),
                                pokemonImageUrl:
                                    pokemonManager.searchedPokemon!.imageUrl,
                              ),
                            ),
                          ],
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: List.generate(
                              pokemonManager.pokemons.length, (index) {
                            final pokemon = pokemonManager.pokemons[index];
                            final isCaptured = pokemonManager.capturedPokemons
                                .any((p) => p.id == pokemon.id);

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
              if (pokemonManager.hasError && !pokemonManager.isLoading)
                ErrorSearch(),
            ],
          ),
        ),

        // Botones flotantes para cambiar de página
        if (!pokemonManager.isLoading &&
            pokemonManager.searchedPokemon == null &&
            !pokemonManager.hasError) ...[
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.extended(
              onPressed: pokemonManager.currentPage > 0 && !isSearchingByType
                  ? () => _changePage(pokemonManager.currentPage - 1)
                  : null,
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
              onPressed: pokemonManager.currentPage < 4 && !isSearchingByType
                  ? () => _changePage(pokemonManager.currentPage + 1)
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
