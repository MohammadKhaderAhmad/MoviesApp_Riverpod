import 'package:flutter/material.dart';

class MovieListTile extends StatelessWidget {
  final String title;
  final String? posterUrl;
  final VoidCallback onDelete;

  const MovieListTile({
    super.key,
    required this.title,
    required this.posterUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading:
            posterUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    posterUrl!,
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.white),
                  ),
                )
                : null,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}
