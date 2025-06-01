import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveis/models/movie_model.dart';
import 'package:moveis/providers/search_provider.dart';
import 'package:moveis/screens/watched_movies_page.dart';
import 'package:moveis/screens/watch_later_page.dart';
import 'movie_details_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      final state = ref.watch(movieSearchProvider);
      final provider = ref.read(movieSearchProvider.notifier);
      return state.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: Colors.red),
            ),
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
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        final movie = movies[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
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
                                    (context, url, error) => const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              MovieDetailsPage(movie: movie),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  color: Color(0xFFE50914),
                                ),
                                tooltip: 'View Details',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
      );
    } else if (_selectedIndex == 1) {
      return const WatchedMoviesPage();
    } else {
      return const WatchLaterPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar:
          _selectedIndex == 0
              ? AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Search for movies...",
                      hintStyle: TextStyle(color: Color(0xFFB3B3B3)),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Color(0xFFB3B3B3)),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    onSubmitted: (value) {
                      ref
                          .read(movieSearchProvider.notifier)
                          .searchMovies(
                            value.isEmpty ? "movies" : value,
                            reset: true,
                          );
                    },
                  ),
                ),
              )
              : null,
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: const Color(0xFF000000),
        indicatorColor: const Color(0xFFE50914),
        surfaceTintColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
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
