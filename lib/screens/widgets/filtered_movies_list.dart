import 'package:flutter/material.dart';
import 'package:movie_app/screens/widgets/movie_details.dart';

class FilteredMoviesList extends StatelessWidget {
  final List<dynamic> movies;
  final String query;

  const FilteredMoviesList({super.key, required this.movies, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
     shrinkWrap: true,
     physics: const NeverScrollableScrollPhysics(),
     itemCount: movies.length,
     itemBuilder: (context, index){
      final movie = movies[index];
      return ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetails(movie: movie)));
        },
        leading: Image.network('https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
        width: 50,
        height: 50,
        ),
        title: Text(movie['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
        subtitle: Text(movie['overview'], style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121)),),
      );
     },


    );
  }
}
