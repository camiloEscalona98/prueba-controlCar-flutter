import 'dart:convert';

import 'package:controlcar/models/pokemon_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PokemonsService {
  final String? baseUrl = dotenv.env['POKE_API'];

  final int maxPokemons = 150;
  final int itemsPerPage = 30;

  Future<List<Pokemon>> fetchPokemons(int limit, int offset) async {
    if (offset + limit > maxPokemons) {
      throw Exception('No se pueden cargar más de $maxPokemons Pokémon.');
    }
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

  Future<List<Pokemon>> searchPokemonByType(String type) async {
    final List<Pokemon> typePokemons = [];
    final response = await http.get(Uri.parse('$baseUrl/type/$type'));

    if (response.statusCode == 200) {
      final typeResponse = json.decode(response.body);

      for (var pokemon in typeResponse['pokemon']) {
        final pokemonDetailResponse =
            await http.get(Uri.parse(pokemon['pokemon']['url']));

        if (pokemonDetailResponse.statusCode == 200) {
          final Pokemon pokemonDetail =
              Pokemon.fromJson(json.decode(pokemonDetailResponse.body));

          if (pokemonDetail.id <= maxPokemons) {
            typePokemons.add(pokemonDetail);
          }
        }
      }
      return typePokemons;
    } else {
      throw Exception('Failed to load Pokémon by type');
    }
  }
}
