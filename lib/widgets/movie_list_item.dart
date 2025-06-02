import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moveis/models/movie_model.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieListItem({super.key, required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: movie.poster,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
            errorWidget:
                (context, url, error) =>
                    const Icon(Icons.broken_image, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  movie.year,
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  movie.type.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFB3B3B3),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.remove_red_eye, color: Color(0xFFE50914)),
            tooltip: 'View Details',
          ),
        ],
      ),
    );
  }
}
