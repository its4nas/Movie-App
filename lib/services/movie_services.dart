import 'package:http/http.dart' as http;

class MovieService {
  final apitoken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYzhkMjU4NTdkYTk2MDVjYTExODlkMWI3NGI1Y2JlYSIsIm5iZiI6MTc0ODA3MzcyNS40OTMsInN1YiI6IjY4MzE3Y2ZkODJmNmE4YTcxMTQxMzg3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.l8jSjjaIczKVTj-az3MOAd1ouu_Yn4G15jGwOYnGMnc';
  Future<dynamic> getPopularMovies() async {
    final headers = {
      'Authorization': 'Bearer $apitoken',
      'accept': 'application/json',
    };

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/popular?language=en-US&page=1'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getTopRatedMovies() async {
    final headers = {
      'Authorization': 'Bearer $apitoken',
      'accept': 'application/json',
    };

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getUpcomingMovies() async {
      final headers = {
      'Authorization': 'Bearer $apitoken',
      'accept': 'application/json',
    };

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getSimilarMovies(int movieId) async {
    final headers = {
      'Authorization': 'Bearer $apitoken',
      'accept': 'application/json',
    };

    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/${movieId}/similar?language=en-US&page=1'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    else {
      throw Exception('Failed to load movies');
    }
  }

}
