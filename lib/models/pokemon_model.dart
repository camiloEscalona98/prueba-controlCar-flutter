class Pokemon {
  final String name;
  final String url;
  final int id;
  final List<TypeDetail> types;
  final String imageUrl;

  Pokemon({
    required this.name,
    required this.url,
    required this.id,
    required this.types,
    required this.imageUrl,
  });

  // Método para convertir un objeto Pokemon a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'id': id,
      'types': types.map((type) => type.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }

  // Método para crear un objeto Pokemon desde JSON
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'];
    final imageUrl = (sprites != null && sprites['front_default'] != null)
        ? sprites['front_default']
        : (json['imageUrl'] != null && json['imageUrl'] != '')
            ? json['imageUrl']
            : 'default_image_url.png';

    return Pokemon(
      name: json['name'] ?? 'Unknown',
      url: json['url'] ?? '',
      id: json['id'] ?? 0,
      types: (json['types'] as List<dynamic>?)
              ?.map((type) {
                final typeJson = type['type'] as Map<String, dynamic>?;
                return typeJson != null ? TypeDetail.fromJson(typeJson) : null;
              })
              .where((typeDetail) => typeDetail != null)
              .cast<TypeDetail>()
              .toList() ??
          [], // Manejo de null
      imageUrl: imageUrl,
    );
  }
}

class TypeDetail {
  final String name;

  TypeDetail({required this.name});

  // Metodo para convertir un objeto typeDetail a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  // Metodo para crear un objeto typeDetail desde JSON
  factory TypeDetail.fromJson(Map<String, dynamic> json) {
    return TypeDetail(name: json['name']);
  }
}

class PokemonListResponse {
  final List<PokemonResult> results;

  PokemonListResponse({required this.results});

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<PokemonResult> resultsList =
        list.map((i) => PokemonResult.fromJson(i)).toList();

    return PokemonListResponse(results: resultsList);
  }
}

class PokemonResult {
  final String name;
  final String url;

  PokemonResult({required this.name, required this.url});

  // Metodo para convertir un objeto PokemonResult a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  // Metodo para crear un objeto PokemonResult desde JSON
  factory PokemonResult.fromJson(Map<String, dynamic> json) {
    return PokemonResult(
      name: json['name'],
      url: json['url'],
    );
  }
}
