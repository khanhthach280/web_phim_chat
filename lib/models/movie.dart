class Movie {
  final int id;
  final String title;
  final String year;
  final String certificate;
  final String runtime;
  final String imdbRating;
  final String metaScore;
  final String posterLink;
  final String overview;
  final String gross;
  final String votes;
  final List<String> actors;
  final List<String> directors;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.certificate,
    required this.runtime,
    required this.imdbRating,
    required this.metaScore,
    required this.posterLink,
    this.overview = '',
    this.gross = '',
    this.votes = '',
    this.actors = const [],
    this.directors = const [],
    this.genres = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      year: json['year'] ?? '',
      certificate: json['certificate'] ?? '',
      runtime: json['runtime'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
      metaScore: json['metaScore'] ?? '',
      posterLink: json['posterLink'] ?? '',
      overview: json['overview'] ?? '',
      gross: json['gross'] ?? '',
      votes: json['votes'] ?? '',
      actors: json['actors'] != null ? List<String>.from(json['actors']) : [],
      directors: json['directors'] != null ? List<String>.from(json['directors']) : [],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'certificate': certificate,
      'runtime': runtime,
      'imdbRating': imdbRating,
      'metaScore': metaScore,
      'posterLink': posterLink,
      'overview': overview,
      'gross': gross,
      'votes': votes,
      'actors': actors,
      'directors': directors,
      'genres': genres,
    };
  }
}
