import 'package:flutter/material.dart';
import 'package:moveis/widgets/info_chip.dart';
import 'package:moveis/widgets/red_button.dart';

class MovieDetailsContent extends StatelessWidget {
  final Map<String, dynamic> fullMovieData;
  final VoidCallback onAddToWatchLater;
  final VoidCallback onAddToWatched;

  const MovieDetailsContent({
    super.key,
    required this.fullMovieData,
    required this.onAddToWatchLater,
    required this.onAddToWatched,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fullMovieData["Title"] ?? "",
            style: const TextStyle(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "(${fullMovieData["Year"]})",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              InfoChip(label: "Genre", value: fullMovieData["Genre"]),
              InfoChip(label: "Runtime", value: fullMovieData["Runtime"]),
              InfoChip(label: "Director", value: fullMovieData["Director"]),
              InfoChip(label: "Actors", value: fullMovieData["Actors"]),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RedButton(
                icon: Icons.watch_later_outlined,
                label: "Watch Later",
                onPressed: onAddToWatchLater,
              ),
              RedButton(
                icon: Icons.check_circle_outline,
                label: "Watched",
                onPressed: onAddToWatched,
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
            fullMovieData["Plot"] ?? "",
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
            "IMDB: ${fullMovieData["imdbRating"]}/10",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          if (fullMovieData["Ratings"] is List)
            ...List.generate(fullMovieData["Ratings"].length, (i) {
              final source = fullMovieData["Ratings"][i];
              return Text(
                "${source["Source"]}: ${source["Value"]}",
                style: const TextStyle(color: Colors.white70),
              );
            }),
        ],
      ),
    );
  }
}
