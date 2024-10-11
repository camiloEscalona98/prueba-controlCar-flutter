import 'package:controlcar/models/pokemon_model.dart';
import 'package:flutter/material.dart';

class PokemonManager {
  List<Pokemon> pokemons = [];
  List<Pokemon> capturedPokemons = [];
  Pokemon? searchedPokemon;
  int currentPage = 0;
  final int itemsPerPage = 30;
  bool isLoading = false;
  bool hasError = false;
  bool pokemonNotAllowed = false;
  TextEditingController searchController = TextEditingController();
}
