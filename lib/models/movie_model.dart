class Movie {
  String imdbID;
  String title;
  String year;
  String type;
  String poster;
  String plot;

  Movie({
    required this.imdbID,
    required this.title,
    required this.year,
    required this.type,
    required this.poster,
    required this.plot,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbID: json["imdbID"] ?? "", // ⭐ مضاف
      title: json["Title"] ?? "",
      year: json["Year"] ?? "",
      type: json["Type"] ?? "",
      poster: json["Poster"] ?? "",
      plot: json["Plot"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "imdbID": imdbID, // ⭐ مضاف
      "Title": title,
      "Year": year,
      "Type": type,
      "Poster": poster,
      "Plot": plot,
    };
  }
}
