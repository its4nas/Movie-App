import 'package:flutter/material.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/services/movie_services.dart';
import 'package:movie_app/screens/widgets/movie_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;

  List<dynamic> _popularMovies = [];
  List<dynamic> _topRatedMovies = [];
  List<dynamic> _upcomingMovies = [];
  List<dynamic> _filteredMovies = [];
  bool _isLoading = true;

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
    // TODO: implement initState
    super.initState();
  }

  fetchMovies() async {
    MovieService movieService = MovieService();
    _popularMovies = await movieService.getPopularMovies();
    _topRatedMovies = await movieService.getTopRatedMovies();
    _upcomingMovies = await movieService.getUpcomingMovies();
    setState(() {
      // _popularMovies = popularMovies;
      // _topRatedMovies = topRatedMovies;
      // _upcomingMovies = upcomingMovies;
      // _filteredMovies = _popularMovies;
      _isLoading = false;
    });
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _isSearching ? 50 : 0,
              ),
              searchBar(),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
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
                                Text(
                                  'Top Reated Movies',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      MovieSlider(topRatedMovies: _topRatedMovies),
                      
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
