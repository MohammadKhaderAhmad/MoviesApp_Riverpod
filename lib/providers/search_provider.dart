import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

final movieSearchProvider =
    StateNotifierProvider<MovieSearchNotifier, AsyncValue<List<Movie>>>(
      (ref) => MovieSearchNotifier(),
    );

class MovieSearchNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  MovieSearchNotifier() : super(const AsyncValue.loading()) {
    searchMovies("movies"); // initial load
  }

  List<Movie> _movies = [];
  int _page = 1;
  bool _hasMore = true;
  String _query = "movies";
  bool get hasMore => _hasMore;

  Future<void> searchMovies(String query, {bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _movies.clear();
      _query = query;
      state = const AsyncValue.loading();
    }

    if (!_hasMore) return;

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.omdbapi.com/?apikey=a01b4302&s=${Uri.encodeComponent(_query)}&page=$_page',
        ),
      );

      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        final List<Movie> newMovies =
            (data['Search'] as List).map((e) => Movie.fromJson(e)).toList();

        _movies.addAll(newMovies);
        _page++;
        if (newMovies.length < 10) _hasMore = false;

        state = AsyncValue.data(List.from(_movies));
      } else {
        _hasMore = false;
        state = AsyncValue.data(List.from(_movies));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
