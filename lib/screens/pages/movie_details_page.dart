import 'package:flutter/material.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/services/movie_services.dart';
import 'package:movie_app/services/database_helper.dart';
import 'package:movie_app/screens/widgets/offline.dart';
import 'dart:io';

class MovieDetails extends StatefulWidget {
  final dynamic movie;
  final bool isFromFavorites;

  const MovieDetails({
    super.key,
    required this.movie,
    this.isFromFavorites = false,
  });
  
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<dynamic> movies = [];
  dynamic detailedMovie;
  bool _isOffline = false;
  String? _errorMessage;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchDetailedMovie();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await DatabaseHelper.instance.isFavorite(widget.movie['movie_id'] ?? widget.movie['id']);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await DatabaseHelper.instance.removeFavorite(widget.movie['movie_id'] ?? widget.movie['id']);
    } else {
      await DatabaseHelper.instance.insertFavorite(widget.movie);
    }
    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  void fetchDetailedMovie() async {
    try {
      MovieService movieService = MovieService();
      // Always fetch full details, even for favorites
      detailedMovie = await movieService.getMovieDetails(widget.movie['movie_id'] ?? widget.movie['id']);
      if (mounted) {
        setState(() {
          _isOffline = false;
          _errorMessage = null;
        });
        _checkFavoriteStatus();
      }
    } on SocketException catch (_) {
      if (mounted) {
        setState(() {
          _isOffline = true;
          _errorMessage = 'No internet connection';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isOffline = true;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isOffline) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie['title']),
          backgroundColor: Colors.black,
        ),
        body: Offline(
          errorMessage: _errorMessage,
          onRetry: () {
            setState(() {
              _isOffline = false;
              _errorMessage = null;
            });
            fetchDetailedMovie();
          },
        ),
      );
    }

    if (detailedMovie == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie['title']),
          backgroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                'https://image.tmdb.org/t/p/w500/${detailedMovie['backdrop_path'] ?? detailedMovie['poster_path']}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 107, 107, 107),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              detailedMovie['title'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleFavorite,
                            icon: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${detailedMovie['vote_average'].toStringAsFixed(1)}/10 IMDb',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (detailedMovie['genres'] != null)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: detailedMovie['genres'].map<Widget>((genre) {
                            return Chip(
                              label: Text(genre['name'], selectionColor: Colors.white),
                              backgroundColor: HomeScreen.primaryColor,
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Length', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${detailedMovie['runtime']}min'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(detailedMovie['spoken_languages'][0]['english_name']),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('${detailedMovie['vote_average'].toStringAsFixed(1)}/10'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(detailedMovie['overview']),
                      if (detailedMovie['credits'] != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Cast',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: detailedMovie['credits']['cast'].length,
                            itemBuilder: (context, index) {
                              final cast = detailedMovie['credits']['cast'][index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500/${cast['profile_path']}',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(cast['name']),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 

