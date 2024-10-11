import 'package:flutter/material.dart';

class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            height: 20,
            width: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 4),
          Container(
            height: 16,
            width: 50,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
