import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveis/providers/search_provider.dart';

class SearchAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final TextEditingController controller;

  const SearchAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search for movies...",
            hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Color(0xFFB3B3B3)),
            contentPadding: EdgeInsets.all(10),
          ),
          onSubmitted: (value) {
            ref
                .read(movieSearchProvider.notifier)
                .searchMovies(value.isEmpty ? "movies" : value, reset: true);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
