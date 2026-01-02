import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  // ⚠️ Android Emulator
  static const String baseUrl = "http://10.0.2.2/bioskop_api";

  // =======================
  // GET ALL MOVIES
  // =======================
  static Future<List<Movie>> getMovies() async {
    final response =
        await http.get(Uri.parse("$baseUrl/movies/get_movies.php"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data film");
    }
  }

  // =======================
  // GET MOVIE DETAIL (BY ID)
  // =======================
  static Future<Movie> getMovieDetail(int movieId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/movies/get_movie_detail.php?id=$movieId"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception("Gagal mengambil detail film");
    }
  }

  // =======================
  // LOGIN
  // =======================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return {
      "success": false,
      "message": "Login gagal (server error)",
    };
  }

  // =======================
  // REGISTER
  // =======================
  static Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nama,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return {
      "success": false,
      "message": "Register gagal (server error)",
    };
  }
}
