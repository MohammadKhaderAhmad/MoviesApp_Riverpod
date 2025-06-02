import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EditMovieBottomSheet extends StatefulWidget {
  final Map<String, dynamic> movie;
  final void Function(double rating, String note) onSave;

  const EditMovieBottomSheet({
    super.key,
    required this.movie,
    required this.onSave,
  });

  @override
  State<EditMovieBottomSheet> createState() => _EditMovieBottomSheetState();
}

class _EditMovieBottomSheetState extends State<EditMovieBottomSheet> {
  late double rating;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    rating = (widget.movie['rating'] ?? 3).toDouble();
    controller = TextEditingController(text: widget.movie['note'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final poster = widget.movie['Poster'] ?? '';
    return SingleChildScrollView(
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
                child: Image.network(poster, height: 200, fit: BoxFit.cover),
              ),
            const SizedBox(height: 12),
            Text(
              widget.movie['Title'],
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
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
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
              onPressed: () => widget.onSave(rating, controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
