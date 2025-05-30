import 'package:flutter/material.dart';
import 'package:movie_app/screens/home.dart';
import 'package:movie_app/services/movie_services.dart';

class MovieDetails extends StatefulWidget {
  final dynamic movie;

  const MovieDetails({
    super.key,
    required this.movie,
  });
  
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<dynamic> movies = [];
  dynamic detailedMovie;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchDetailedMovie();
  }

  void fetchMovieDetails() async{
    MovieService movieService = MovieService();
    movies = await movieService.getSimilarMovies(widget.movie['id']);
  }

  void fetchDetailedMovie() async {
    MovieService movieService = MovieService();
    detailedMovie = await movieService.getMovieDetails(widget.movie['id']);
    setState(() {});
  }

  Widget build(BuildContext context) {
    if (detailedMovie == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie['title']),
          backgroundColor: Colors.black,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: 
      Column(
        children: [
          Stack(
            children: [
              // Backdrop image
          Image.network(
            'https://image.tmdb.org/t/p/w500/${detailedMovie['backdrop_path']}', // Using backdrop_path for wider image
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Back button
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Bookmark button
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.bookmark_border, color: Colors.white),
              onPressed: () {},
            ),
          ),


        ],
      ),
                // Movie details container
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 107, 107, 107),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and bookmark
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              detailedMovie['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.bookmark_border),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '${detailedMovie['vote_average'].toStringAsFixed(1)}/10 IMDb',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Genres
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: detailedMovie['genres'].map<Widget>((genre) {
                          return Chip(
                            label: Text(genre['name'], selectionColor: Colors.white,),
                            backgroundColor: HomeScreen.primaryColor,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16),

                      // Length, Language, Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Length', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('${detailedMovie['runtime']}min'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(detailedMovie['spoken_languages'][0]['english_name']),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('${detailedMovie['vote_average'].toStringAsFixed(1)}/10'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(detailedMovie['overview']),
                      SizedBox(height: 16),

                      // Cast
                      Text(
                        'Cast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 120, // Adjust height as needed
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
                                  SizedBox(height: 4),
                                  Text(cast['name']),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Watch Now button (commented out)
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Watch Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeScreen.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                textStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: 32), // Space before similar movies section
          
      ]
      ),
    );
  }
} 

