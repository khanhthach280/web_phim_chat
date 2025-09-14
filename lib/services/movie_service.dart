import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<List<Movie>> getMovies() async {
    print('======= getMovies');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("========= khanh success");
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Movie.fromJson(json)).toList();
      } else {
        print('======== khanh failed: ${response.statusCode}');
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      print('======== Error: $e');
      
      // Nếu không thể kết nối đến server, trả về mock data
      if (e.toString().contains('ClientException') || 
          e.toString().contains('Failed to fetch') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('CORS')) {
        print('======== Using mock data due to server connection issue');
      }
      
      throw Exception('Error fetching movies: $e');
    }
  }

  Future<Movie> getMovieById(int id) async {
    print('======= getMovieById: $id');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movies/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("========= khanh success getMovieById");
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        print('======== khanh failed getMovieById: ${response.statusCode}');
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      print('======== Error getMovieById: $e');
      
      // Nếu không thể kết nối đến server, trả về mock data
      if (e.toString().contains('ClientException') || 
          e.toString().contains('Failed to fetch') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('CORS')) {
        print('======== Using mock data for movie details due to server connection issue');
        return _getMockMovieById(id);
      }
      
      throw Exception('Error fetching movie details: $e');
    }
  }

  // Mock data cho chi tiết phim
  Movie _getMockMovieById(int id) {
    switch (id) {
      case 1:
        return Movie(
          id: 1,
          title: "The Godfather",
          year: "1972",
          certificate: "A",
          runtime: "175 min",
          imdbRating: "9.2",
          metaScore: "100",
          posterLink: "https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY98_CR1,0,67,98_AL_.jpg",
          overview: "An organized crime dynasty's aging patriarch transfers control of his clandestine empire to his reluctant son.",
          gross: "Diane Keaton",
          votes: "James Caan",
          actors: ["Marlon Brando", "Al Pacino", "James Caan", "Diane Keaton"],
          directors: ["Francis Ford Coppola"],
          genres: ["Crime", "Drama"],
        );
      case 2:
        return Movie(
          id: 2,
          title: "12 Angry Men",
          year: "1957",
          certificate: "U",
          runtime: "96 min",
          imdbRating: "9.0",
          metaScore: "96",
          posterLink: "https://m.media-amazon.com/images/M/MV5BMWU4N2FjNzYtNTVkNC00NzQ0LTg0MjAtYTJlMjFhNGUxZDFmXkEyXkFqcGdeQXVyNjc1NTYyMjg@._V1_UX67_CR0,0,67,98_AL_.jpg",
          overview: "A jury holdout attempts to prevent a miscarriage of justice by forcing his colleagues to reconsider the evidence.",
          gross: "Henry Fonda",
          votes: "Lee J. Cobb",
          actors: ["Henry Fonda", "Lee J. Cobb", "Martin Balsam", "John Fiedler"],
          directors: ["Sidney Lumet"],
          genres: ["Crime", "Drama"],
        );
      case 3:
        return Movie(
          id: 3,
          title: "The Shawshank Redemption",
          year: "1994",
          certificate: "A",
          runtime: "142 min",
          imdbRating: "9.3",
          metaScore: "80",
          posterLink: "https://m.media-amazon.com/images/M/MV5BNDE3ODcxYzMtY2YzZC00NmNlLWJiNDMtZDViZWM2MzIxZDYwXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_UX67_CR0,0,67,98_AL_.jpg",
          overview: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.",
          gross: "Tim Robbins",
          votes: "Morgan Freeman",
          actors: ["Tim Robbins", "Morgan Freeman", "Bob Gunton", "William Sadler"],
          directors: ["Frank Darabont"],
          genres: ["Drama"],
        );
      case 4:
        return Movie(
          id: 4,
          title: "Pulp Fiction",
          year: "1994",
          certificate: "A",
          runtime: "154 min",
          imdbRating: "8.9",
          metaScore: "94",
          posterLink: "https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_UY98_CR0,0,67,98_AL_.jpg",
          overview: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.",
          gross: "John Travolta",
          votes: "Samuel L. Jackson",
          actors: ["John Travolta", "Samuel L. Jackson", "Uma Thurman", "Bruce Willis"],
          directors: ["Quentin Tarantino"],
          genres: ["Crime", "Drama"],
        );
      case 5:
        return Movie(
          id: 5,
          title: "(500) Days of Summer",
          year: "2009",
          certificate: "UA",
          runtime: "95 min",
          imdbRating: "7.7",
          metaScore: "76",
          posterLink: "https://m.media-amazon.com/images/M/MV5BMTk5MjM4OTU1OV5BMl5BanBnXkFtZTcwODkzNDIzMw@@._V1_UX67_CR0,0,67,98_AL_.jpg",
          overview: "After his girlfriend breaks up with him, a young man reflects on their relationship to try to figure out where things went wrong.",
          gross: "Zooey Deschanel",
          votes: "Joseph Gordon-Levitt",
          actors: ["Joseph Gordon-Levitt", "Zooey Deschanel", "Geoffrey Arend", "Chloe Grace Moretz"],
          directors: ["Marc Webb"],
          genres: ["Comedy", "Drama", "Romance"],
        );
      default:
        return Movie(
          id: id,
          title: "Unknown Movie",
          year: "Unknown",
          certificate: "Unknown",
          runtime: "Unknown",
          imdbRating: "0.0",
          metaScore: "0",
          posterLink: "",
          overview: "Movie details not available.",
          gross: "Unknown",
          votes: "Unknown",
          actors: [],
          directors: [],
          genres: [],
        );
    }
  }
}