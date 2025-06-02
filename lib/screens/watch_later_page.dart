import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveis/providers/watch_later_provider.dart';
import 'package:moveis/widgets/later_movie_list_tile.dart';

class WatchLaterPage extends ConsumerStatefulWidget {
  const WatchLaterPage({super.key});

  @override
  ConsumerState<WatchLaterPage> createState() => _WatchLaterPageState();
}

class _WatchLaterPageState extends ConsumerState<WatchLaterPage> {
  @override
  void initState() {
    super.initState();
    ref.read(watchLaterProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final watchLaterMovies = ref.watch(watchLaterProvider);
    final notifier = ref.read(watchLaterProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text("Watch Later"),
        backgroundColor: Colors.red,
      ),
      body:
          watchLaterMovies.isEmpty
              ? const Center(
                child: Text(
                  "No movies in watch later list.",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: watchLaterMovies.length,
                itemBuilder: (context, index) {
                  final movie = watchLaterMovies[index];
                  return MovieListTile(
                    title: movie['Title'] ?? 'No Title',
                    posterUrl: movie['Poster'],
                    onDelete: () => notifier.delete(index),
                  );
                },
              ),
    );
  }
}
