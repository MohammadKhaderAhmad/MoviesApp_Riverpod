import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final watchedMoviesProvider =
    StateNotifierProvider<WatchedMoviesNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return WatchedMoviesNotifier();
    });

class WatchedMoviesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  WatchedMoviesNotifier() : super([]) {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('watched') ?? [];
    state = list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('watched', list);
  }

  Future<void> add(Map<String, dynamic> movie) async {
    final title = movie['Title'];
    final exists = state.any((m) => m['Title'] == title);
    if (!exists) {
      state = [...state, movie];
      await _save();
    }
  }

  void delete(int index) async {
    final updated = [...state]..removeAt(index);
    state = updated;
    await _save();
  }

  void update(int index, double rating, String note) async {
    final updated = [...state];
    updated[index]['rating'] = rating;
    updated[index]['note'] = note;
    state = updated;
    await _save();
  }
}
