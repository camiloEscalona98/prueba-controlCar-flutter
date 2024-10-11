import 'package:controlcar/models/pokemon_model.dart';
import 'package:controlcar/screens/home/widgets/bottom_modal_team_widget.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.searchController,
    required this.capturedPokemons,
    required this.onSearch,
  });

  final TextEditingController searchController;
  final List<Pokemon> capturedPokemons;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  onSearch();
                },
              ),
              hintText: 'Buscar Pokémon',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.amber, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return BottomModalTeam(
                    capturedPokemons: capturedPokemons,
                  );
                },
              );
            },
            child: Image.network(
              'https://i.pinimg.com/originals/da/d4/55/dad455563bac8b9198130aa5f75fb930.png',
              width: 32,
            ),
          ),
        ),
      ],
    );
  }
}
