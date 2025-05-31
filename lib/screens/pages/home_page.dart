import 'package:flutter/material.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/screens/widgets/offline.dart';
import 'package:movie_app/services/movie_services.dart';
import 'package:movie_app/screens/widgets/movie_slider.dart';
import 'package:movie_app/screens/widgets/horizontal_card_scroller.dart';
import 'package:movie_app/screens/widgets/vertical_card_scroller.dart';
import 'package:movie_app/screens/widgets/filtered_movies_list.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  String _searchQuery = '';

  List<dynamic> _popularMovies = [];
  List<dynamic> _topRatedMovies = [];
  List<dynamic> _upcomingMovies = [];
  List<dynamic> _filteredMovies = [];
  bool _isLoading = true;
  bool _isOffline = false;
  String? _errorMessage;

  void filteredMovies(String query) {
    setState(() {
      _filteredMovies = _popularMovies.where((movie) => movie['title'].toLowerCase().
    toLowerCase().contains(query.toLowerCase())).toList()+
    _topRatedMovies.where((movie) => movie['title'].toLowerCase().
    toLowerCase().contains(query.toLowerCase())).toList()+
    _upcomingMovies.where((movie) => movie['title'].toLowerCase().
    toLowerCase().contains(query.toLowerCase())).toList();

    _isSearching = false;
    });
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onTap: () => setState(() => _isSearching = true),
        onSubmitted: (_) => setState(() => _isSearching = false),
        onChanged: (query) => {
          if (query.isEmpty) {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
              _filteredMovies = [];
            }),
          } else {
            setState(() {
              _searchQuery = query;
              filteredMovies(query);
              _isSearching = true;
            }),
          },
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Movies & Show',
          hintStyle: TextStyle(color: Colors.grey[400], height: 2.5),
          prefixIcon: const Icon(
            Icons.search,
            color: HomeScreen.primaryColor,
            size: 30,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }


  @override
  void initState() {
    fetchMovies();
    super.initState();
  }

  fetchMovies() async {
    try {
      setState(() {
        _isLoading = true;
        _isOffline = false;
        _errorMessage = null;
      });

      MovieService movieService = MovieService();
      _popularMovies = await movieService.getPopularMovies().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );
      _topRatedMovies = await movieService.getTopRatedMovies().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );
      _upcomingMovies = await movieService.getUpcomingMovies().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOffline = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isOffline = true;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isSearching) {
          setState(() => _isSearching = false);
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await fetchMovies();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: _isSearching ? 50 : 0,
                ),
                searchBar(),
                _isLoading
                    ? const Center(child: CircularProgressIndicator()):
                    _isSearching?
                    Column(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Search Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        ),
                        FilteredMoviesList(movies: _filteredMovies, query: _searchQuery),
                      ],
                    )
                    : _isOffline
                        ? Offline(
                            errorMessage: _errorMessage,
                            onRetry: () {
                              setState(() {
                                _isLoading = true;
                                _isOffline = false;
                                _errorMessage = null;
                              });
                              fetchMovies();
                            },
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      // Your onTap action here
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Top Rated Movies',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              MovieSlider(topRatedMovies: _topRatedMovies),
                              const SizedBox(height: 25),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      // Your onTap action here
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Popular Movies',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              HorizontalCardScroller(movies: _popularMovies),
                              const SizedBox(height: 25),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      // Your onTap action here
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Upcoming Movies',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              VerticalCardScroller(movies: _upcomingMovies),
                              const SizedBox(height: 120),
                            ],
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
