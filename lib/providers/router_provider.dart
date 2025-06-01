// router_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moveis/models/movie_model.dart';
import 'package:moveis/screens/splash_screen.dart';
import 'package:moveis/screens/search_page.dart';
import 'package:moveis/screens/movie_details_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(tabIndex: 0),
      ),
      GoRoute(
        path: '/watched',
        builder: (context, state) => const SearchPage(tabIndex: 1),
      ),
      GoRoute(
        path: '/later',
        builder: (context, state) => const SearchPage(tabIndex: 2),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) {
          final movie = state.extra as Movie;
          return MovieDetailsPage(movie: movie);
        },
      ),
    ],
  );
});
