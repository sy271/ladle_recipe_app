class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.cat,
    required this.time,
    required this.rating,
    required this.photo,
    required this.heroPhoto,
    required this.serves,
    required this.by,
  });

  final String id;
  final String name;
  final String cat;
  final String time;
  final String rating;
  final String photo;
  final String heroPhoto;
  final String serves;
  final String by;
}
