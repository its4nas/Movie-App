import 'package:flutter/material.dart';
import 'package:movie_app/screens/pages/movie_details_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class HorizontalCardScroller extends StatelessWidget {
  final List<dynamic> movies;

  const HorizontalCardScroller({
    super.key,
    required this.movies,
  });

  Future<bool> checkConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () async {
                  try {
                    bool isConnected = await checkConnectivity();
                    if (!isConnected) {
                      throw SocketException('No internet connection');
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(movie: movie),
                      ),
                    );
                  } catch (e) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(movie: movie),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 140,
                  margin: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: Icon(
                              Icons.movie,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
