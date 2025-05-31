import 'package:flutter/material.dart';
import 'package:movie_app/screens/pages/movie_details_page.dart';

class HorizontalCardScroller extends StatelessWidget {
  final List<dynamic> movies;

  const HorizontalCardScroller({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: 
          List.generate(movies.length, (index){
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(movie: movie),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network('https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      child: Text(movie['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Icon(Icons.person_2_rounded, color: Colors.grey,),
                        const SizedBox(width: 5),
                        Text(movie['popularity'].toString(), style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.yellow,),
                        const SizedBox(width: 5),
                        Text(movie['vote_average'].toString(), style: const TextStyle(fontSize: 12),),
                      ],
                    ),
                  ]
                ),
              ),
            );
          },
      ),
      ),
    );
  }
}
