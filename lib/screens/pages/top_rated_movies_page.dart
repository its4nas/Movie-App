import 'package:flutter/material.dart';
import 'package:movie_app/services/movie_services.dart';
import 'package:movie_app/screens/widgets/vertical_card_scroller.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
    List<dynamic> _topRatedMovies = [];
    bool _isLoading = true;

    @override
    void initState() {
      fetchMovies();
      // TODO: implement initState
      super.initState();
    }

    fetchMovies() async {
      MovieService movieService = MovieService();
      _topRatedMovies = await movieService.getTopRatedMovies();
      setState(() {
        _isLoading = false;
      });
    }


  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
        },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('Top Rated Movies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : VerticalCardScroller(movies: _topRatedMovies),
              const SizedBox(height: 100),
              ],
          )
          ),
      ),
    );
  }

}