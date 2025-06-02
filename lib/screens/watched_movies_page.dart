import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveis/providers/watched_movies_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moveis/widgets/edit_movie_bottom_sheet.dart';
import 'package:moveis/widgets/watched_movie_tile.dart';

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
                  return WatchedMovieTile(
                    movie: movie,
                    onEdit: () => _editMovie(context, notifier, movie, index),
                    onDelete: () => notifier.delete(index),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      builder:
          (context) => EditMovieBottomSheet(
            movie: movie,
            onSave: (rating, note) {
              notifier.update(index, rating, note);
              Navigator.pop(context);
            },
          ),
    );
  }
}
