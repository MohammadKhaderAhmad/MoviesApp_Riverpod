import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moveis/models/movie_model.dart';
import 'package:moveis/providers/search_provider.dart';
import 'package:moveis/screens/watched_movies_page.dart';
import 'package:moveis/screens/watch_later_page.dart';
import 'package:moveis/widgets/movie_list_item.dart';
import 'package:moveis/widgets/search_app_bar.dart';

class SearchPage extends ConsumerStatefulWidget {
  final int tabIndex;
  const SearchPage({super.key, this.tabIndex = 0});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tabIndex;
    _scrollController.addListener(() {
      final provider = ref.read(movieSearchProvider.notifier);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          provider.hasMore) {
        provider.searchMovies(
          _controller.text.isEmpty ? "movies" : _controller.text,
        );
      }
    });
  }

  Widget _buildSearchBody(
    AsyncValue<List<Movie>> state,
    MovieSearchNotifier provider,
  ) {
    return state.when(
      loading:
          () =>
              const Center(child: CircularProgressIndicator(color: Colors.red)),
      error:
          (e, _) => Center(
            child: Text(
              'Error: $e',
              style: const TextStyle(color: Colors.white),
            ),
          ),
      data:
          (movies) =>
              movies.isEmpty
                  ? const Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                  : ListView.builder(
                    controller: _scrollController,
                    itemCount: movies.length + (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == movies.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          ),
                        );
                      }
                      final movie = movies[index];
                      return MovieListItem(
                        movie: movie,
                        onTap: () => context.push('/details', extra: movie),
                      );
                    },
                  ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieSearchProvider);
    final provider = ref.read(movieSearchProvider.notifier);

    Widget bodyContent;
    if (_selectedIndex == 0) {
      bodyContent = _buildSearchBody(state, provider);
    } else if (_selectedIndex == 1) {
      bodyContent = const WatchedMoviesPage();
    } else {
      bodyContent = const WatchLaterPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar:
          _selectedIndex == 0 ? SearchAppBar(controller: _controller) : null,
      body: bodyContent,
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: const Color(0xFF000000),
        indicatorColor: const Color(0xFFE50914),
        surfaceTintColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: Colors.white),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle, color: Colors.white),
            label: 'Watched',
          ),
          NavigationDestination(
            icon: Icon(Icons.watch_later_outlined),
            selectedIcon: Icon(Icons.watch_later, color: Colors.white),
            label: 'Watch Later',
          ),
        ],
      ),
    );
  }
}
