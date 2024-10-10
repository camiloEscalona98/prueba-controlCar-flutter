import 'dart:convert';

import 'package:controlcar/models/pokemon_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PokemonsService {
  final String? baseUrl = dotenv.env['POKE_API'];
  Future<List<Pokemon>> fetchPokemons(int limit, int offset) async {
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

  Future<List<Pokemon>> searchPokemonByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$name'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [Pokemon.fromJson(data)]; // Retorna solo un Pokémon
    } else {
      throw Exception('No Pokémon found with the name $name');
    }
  }

  // Search Pokémon by type with pagination
  Future<List<Pokemon>> searchPokemonByType(
      String type, int limit, int offset) async {
    final response = await http.get(Uri.parse('$baseUrl/type/$type'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['pokemon'];

      // Paginar los resultados obtenidos por tipo
      List<Pokemon> paginatedResults = results
          .skip(offset)
          .take(limit)
          .map<Pokemon>((item) => Pokemon.fromJson(item['pokemon']))
          .toList();

      return paginatedResults;
    } else {
      throw Exception('No Pokémon found with the type $type');
    }
  }
}
