// search widget

import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onChanged;

  const SearchWidget({
    super.key,
    required this.searchQuery,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        style: TextStyle(color: Colors.white), // Set input text color to white
        decoration: const InputDecoration(
          hintText: 'Поиск...',
          hintStyle:
              TextStyle(color: Colors.grey), // Optional: Style for hint text
          border: OutlineInputBorder(),
        ),

        onChanged: onChanged,
      ),
    );
  }
}
