class Book {
  final int index;
  final String number;
  final String title;
  final String originalTitle;
  final String releaseDate;
  final String description;
  final String pages;
  final String image;

  Book({
    required this.index,
    required this.number,
    required this.title,
    required this.originalTitle,
    required this.releaseDate,
    required this.description,
    required this.pages,
    required this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      index: json['index'] ?? 0,
      number: json['number']?.toString() ?? '',
      title: json['title'] ?? '',
      originalTitle: json['originalTitle'] ?? '',
      releaseDate: json['releaseDate']?.toString() ?? '',
      description: json['description'] ?? '',
      pages: json['pages']?.toString() ?? '',
      image: json['cover'] ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'number': number,
      'title': title,
      'originalTitle': originalTitle,
      'releaseDate': releaseDate,
      'description': description,
      'pages': pages,
      'image': image,
    };
  }

}
