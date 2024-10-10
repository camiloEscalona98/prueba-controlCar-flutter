import 'dart:convert';

import 'package:controlcar/models/pokemon_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PokemonsService {
  final String? baseUrl = dotenv.env['POKE_API'];

  // Limite máximo de Pokémon permitidos
  final int maxPokemons = 150;
  final int itemsPerPage = 30;

  Future<List<Pokemon>> fetchPokemons(int limit, int offset) async {
    // Validar que no se supere el límite de 150 Pokémon
    if (offset + limit > maxPokemons) {
      throw Exception('No se pueden cargar más de $maxPokemons Pokémon.');
    }

    // Ajustar el límite en caso de que la cantidad solicitada exceda el máximo permitido
    if (limit > maxPokemons - offset) {
      limit = maxPokemons - offset;
    }

    final response = await http.get(Uri.parse(
      '$baseUrl/pokemon?limit=$limit&offset=$offset',
    ));

    if (response.statusCode == 200) {
      final pokemonListResponse =
          PokemonListResponse.fromJson(json.decode(response.body));
      List<Pokemon> pokemons = [];

      // Recorrer los resultados y obtener los detalles de cada Pokémon
      for (var result in pokemonListResponse.results) {
        final pokemonDetailsResponse = await http.get(Uri.parse(result.url));
        if (pokemonDetailsResponse.statusCode == 200) {
          final pokemon =
              Pokemon.fromJson(json.decode(pokemonDetailsResponse.body));
          pokemons.add(pokemon);
        } else {
          throw Exception('Failed to load Pokémon details');
        }
      }
      return pokemons;
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  Future<Pokemon?> fetchPokemonByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      // Si no se encuentra el Pokémon
      return null;
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }
}
