import 'package:flutter/material.dart';
import 'package:movie_app/screens/widgets/offline.dart';
import 'package:movie_app/services/movie_services.dart';
import 'package:movie_app/screens/widgets/vertical_card_scroller.dart';
import 'dart:async';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
    List<dynamic> _topRatedMovies = [];
    bool _isLoading = true;
    bool _isOffline = false;
    String? _errorMessage;

    @override
    void initState() {
      fetchMovies();
      // TODO: implement initState
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
        _topRatedMovies = await movieService.getTopRatedMovies().timeout(
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


  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchMovies();
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
                  : VerticalCardScroller(movies: _topRatedMovies),
              const SizedBox(height: 100),
              ],
          )
          ),
      ),
    );
  }

}