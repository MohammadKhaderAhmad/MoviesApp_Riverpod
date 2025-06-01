import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveis/providers/watched_movies_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WatchedMoviesPage extends ConsumerStatefulWidget {
  const WatchedMoviesPage({super.key});

  @override
  ConsumerState<WatchedMoviesPage> createState() => _WatchedMoviesPageState();
}

class _WatchedMoviesPageState extends ConsumerState<WatchedMoviesPage> {
  @override
  void initState() {
    super.initState();
    ref.read(watchedMoviesProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final watchedMovies = ref.watch(watchedMoviesProvider);
    final notifier = ref.read(watchedMoviesProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text("Watched Movies"),
        backgroundColor: Colors.red,
      ),
      body:
          watchedMovies.isEmpty
              ? const Center(
                child: Text(
                  "No watched movies yet.",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: watchedMovies.length,
                itemBuilder: (context, index) {
                  final movie = watchedMovies[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (movie['Poster'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie['Poster'],
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie['Title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (movie['rating'] != null)
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Icon(
                                        i < (movie['rating'] as double).round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 20,
                                      );
                                    }),
                                  ),
                                if (movie['note'] != null &&
                                    movie['note'].toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      movie['note'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed:
                                    () => _editMovie(
                                      context,
                                      notifier,
                                      movie,
                                      index,
                                    ),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white70,
                                ),
                              ),
                              IconButton(
                                onPressed: () => notifier.delete(index),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  void _editMovie(
    BuildContext context,
    WatchedMoviesNotifier notifier,
    Map<String, dynamic> movie,
    int index,
  ) {
    double rating = (movie['rating'] ?? 3).toDouble();
    final controller = TextEditingController(text: movie['note'] ?? '');
    final poster = movie['Poster'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      builder:
          (context) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (poster.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        poster,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    movie['Title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (value) => rating = value,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Write your review...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      notifier.update(index, rating, controller.text.trim());
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
