import 'package:flutter/material.dart' hide CarouselController;
import 'package:carousel_slider/carousel_slider.dart';

class MovieSlider extends StatelessWidget {
  final List<dynamic> topRatedMovies;
  MovieSlider({Key? key, required this.topRatedMovies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: topRatedMovies.map((movie) {
        return GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetail(movieId: movie['id'])));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500/${movie['backdrop_path']}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Icon(
                      Icons.movie,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: Duration(seconds: 1),
        enableInfiniteScroll: true,
        pageSnapping: true,
        enlargeCenterPage: true,
        viewportFraction: 0.75,
      ),
    );
  }
}