import 'package:flutter/material.dart';

class WatchedMovieTile extends StatelessWidget {
  final Map<String, dynamic> movie;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const WatchedMovieTile({
    super.key,
    required this.movie,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rating = (movie['rating'] ?? 0).toDouble();
    final note = movie['note'] ?? '';
    final poster = movie['Poster'];

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
            if (poster != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  poster,
                  width: 60,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['Title'] ?? 'No Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (rating > 0)
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < rating.round() ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  if (note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        note,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
