import 'dart:ui';

import 'package:controlcar/utils/colors.dart';
import 'package:controlcar/utils/text_formatter.dart';
import 'package:flutter/material.dart';

class PokemonListItem extends StatelessWidget {
  final String pokemonName;
  final String pokemonNumber;
  final List<String> pokemonTypes;
  final String pokemonImageUrl;
  final bool isCaptured;

  const PokemonListItem({
    Key? key,
    required this.pokemonName,
    required this.pokemonNumber,
    required this.pokemonTypes,
    required this.pokemonImageUrl,
    required this.isCaptured,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalizeFirstLetter(pokemonName),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '#$pokemonNumber',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      isCaptured
                          ? Image.asset(
                              'assets/img/pokeball.png',
                              height: 25,
                              width: 25,
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: pokemonTypes
                    .map(
                      (type) => Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: PokemonTypeColorUtils.getTypeColor(type),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          capitalizeFirstLetter(type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/img/pokeball.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned(
          right: -15,
          bottom: 0,
          child: Image.network(
            pokemonImageUrl,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
