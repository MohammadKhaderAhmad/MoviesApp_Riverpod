import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final watchLaterProvider =
    StateNotifierProvider<WatchLaterNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      return WatchLaterNotifier();
    });

class WatchLaterNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  WatchLaterNotifier() : super([]) {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('watch_later') ?? [];
    state = list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = state.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('watch_later', list);
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
}
