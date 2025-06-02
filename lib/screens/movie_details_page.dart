import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moveis/models/movie_model.dart';
import 'package:moveis/providers/watched_movies_provider.dart';
import 'package:moveis/providers/watch_later_provider.dart';
import 'package:moveis/widgets/movie_details_content.dart';

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
                    child: MovieDetailsContent(
                      fullMovieData: fullMovieData!,
                      onAddToWatchLater: addToWatchLater,
                      onAddToWatched: addToWatched,
                    ),
                  ),
                ],
              ),
    );
  }
}
