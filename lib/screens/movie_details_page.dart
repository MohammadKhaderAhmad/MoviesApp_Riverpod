import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moveis/models/movie_model.dart';
import 'package:moveis/providers/watched_movies_provider.dart';
import 'package:moveis/providers/watch_later_provider.dart';
import 'package:moveis/screens/watch_later_page.dart';
import 'package:moveis/screens/watched_movies_page.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  final Movie movie;
  const MovieDetailsPage({super.key, required this.movie});

  @override
  ConsumerState<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  Map<String, dynamic>? fullMovieData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final url = Uri.parse(
      "http://www.omdbapi.com/?t=${Uri.encodeComponent(widget.movie.title)}&y=${widget.movie.year}&plot=full&apikey=a01b4302",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        fullMovieData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addToWatchLater() async {
    final notifier = ref.read(watchLaterProvider.notifier);
    await notifier.add(widget.movie.toJson());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Added to Watch Later")));
  }

  Future<void> addToWatched() async {
    final notifier = ref.read(watchedMoviesProvider.notifier);
    await notifier.add(widget.movie.toJson());
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Added to Watched")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
              : fullMovieData == null || fullMovieData!["Response"] == "False"
              ? const Center(
                child: Text(
                  "Failed to load movie details",
                  style: TextStyle(color: Colors.white),
                ),
              )
              : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: fullMovieData!["Poster"] ?? '',
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => const Icon(
                              Icons.broken_image,
                              color: Colors.white,
                            ),
                      ),
                      title: null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullMovieData!["Title"] ?? "",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "(${fullMovieData!["Year"]})",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 6,
                            children: [
                              _infoChip("Genre", fullMovieData!["Genre"]),
                              _infoChip("Runtime", fullMovieData!["Runtime"]),
                              _infoChip("Director", fullMovieData!["Director"]),
                              _infoChip("Actors", fullMovieData!["Actors"]),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: addToWatchLater,
                                icon: const Icon(Icons.watch_later_outlined),
                                label: const Text("Watch Later"),
                                style: redButtonStyle,
                              ),
                              ElevatedButton.icon(
                                onPressed: addToWatched,
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text("Watched"),
                                style: redButtonStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.grey),
                          const Text(
                            "📝 Plot",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fullMovieData!["Plot"] ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Colors.grey),
                          const Text(
                            "⭐ Ratings",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "IMDB: ${fullMovieData!["imdbRating"]}/10",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          if (fullMovieData!["Ratings"] is List)
                            ...List.generate(fullMovieData!["Ratings"].length, (
                              i,
                            ) {
                              final source = fullMovieData!["Ratings"][i];
                              return Text(
                                "${source["Source"]}: ${source["Value"]}",
                                style: const TextStyle(color: Colors.white70),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _infoChip(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: $value",
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  final redButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFE50914),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );
}
