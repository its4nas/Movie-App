import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MovieService {
  final apitoken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYzhkMjU4NTdkYTk2MDVjYTExODlkMWI3NGI1Y2JlYSIsIm5iZiI6MTc0ODA3MzcyNS40OTMsInN1YiI6IjY4MzE3Y2ZkODJmNmE4YTcxMTQxMzg3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.l8jSjjaIczKVTj-az3MOAd1ouu_Yn4G15jGwOYnGMnc';

  Future<dynamic> _makeRequest(String url) async {
    try {
      final headers = {
        'Authorization': 'Bearer $apitoken',
        'accept': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
         return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }

    } on SocketException {
      throw Exception('No internet connection. Please check your network settings.');
    } on HttpException {
      throw Exception('Could not connect to the server. Please try again later.');
    } on FormatException {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<dynamic>> getPopularMovies() async {
    final responseData = await _makeRequest('https://api.themoviedb.org/3/movie/popular?language=en-US&page=1');
    if (responseData != null && responseData['results'] is List) {
      return responseData['results'];
    } else {
      throw Exception('Failed to load popular movies: Invalid response format.');
    }
  }

  Future<List<dynamic>> getTopRatedMovies() async {
    final responseData = await _makeRequest('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1');
    if (responseData != null && responseData['results'] is List) {
      return responseData['results'];
    } else {
      throw Exception('Failed to load top rated movies: Invalid response format.');
    }
  }

  Future<List<dynamic>> getUpcomingMovies() async {
    final responseData = await _makeRequest('https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1');
    if (responseData != null && responseData['results'] is List) {
      return responseData['results'];
    } else {
      throw Exception('Failed to load upcoming movies: Invalid response format.');
    }
  }

  Future<List<dynamic>> getSimilarMovies(int movieId) async {
    final responseData = await _makeRequest('https://api.themoviedb.org/3/movie/${movieId}/similar?language=en-US&page=1');
    if (responseData != null && responseData['results'] is List) {
      return responseData['results'];
    } else {
      throw Exception('Failed to load similar movies: Invalid response format.');
    }
  }

  Future<dynamic> getMovieDetails(int movieId) async {
    return _makeRequest('https://api.themoviedb.org/3/movie/${movieId}?append_to_response=credits,videos');
  }
}
