import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveis/providers/watch_later_provider.dart';

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
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading:
                          movie['Poster'] != null
                              ? ClipRRect(
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
                              )
                              : null,
                      title: Text(
                        movie['Title'] ?? 'No Title',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () => notifier.delete(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
