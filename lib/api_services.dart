import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'movie_models.dart';

class ApiServices {
  // Obtener películas populares
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/movie/popular?api_key=${Constants.apiKey}&language=es-ES&page=1'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar populares');
    }
  }

  // Buscar películas
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/search/movie?api_key=${Constants.apiKey}&language=es-ES&query=${Uri.encodeComponent(query)}&page=1'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar');
    }
  }
}
