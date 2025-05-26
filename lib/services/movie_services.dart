import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MovieService {
  final apitoken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYzhkMjU4NTdkYTk2MDVjYTExODlkMWI3NGI1Y2JlYSIsIm5iZiI6MTc0ODA3MzcyNS40OTMsInN1YiI6IjY4MzE3Y2ZkODJmNmE4YTcxMTQxMzg3YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.l8jSjjaIczKVTj-az3MOAd1ouu_Yn4G15jGwOYnGMnc';

  Future<List<dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode == 200) {
      return (json.decode(response.body))['results'];
    } else {
      throw Exception('Failed to load movies: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> _makeRequest(String url) async {
    try {
      final headers = {
        'Authorization': 'Bearer $apitoken',
        'accept': 'application/json',
      };

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      return await _handleResponse(response);
    } on SocketException catch (e) {
      throw Exception('No internet connection. Please check your network settings.');
    } on HttpException catch (e) {
      throw Exception('Could not connect to the server. Please try again later.');
    } on FormatException catch (e) {
      throw Exception('Invalid response format from server.');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<dynamic>> getPopularMovies() async {
    return _makeRequest('https://api.themoviedb.org/3/movie/popular?language=en-US&page=1');
  }

  Future<List<dynamic>> getTopRatedMovies() async {
    return _makeRequest('https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1');
  }

  Future<List<dynamic>> getUpcomingMovies() async {
    return _makeRequest('https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1');
  }

  Future<List<dynamic>> getSimilarMovies(int movieId) async {
    return _makeRequest('https://api.themoviedb.org/3/movie/${movieId}/similar?language=en-US&page=1');
  }
}
