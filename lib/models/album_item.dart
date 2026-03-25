class AlbumItem {
  final String imagePath;
  final String title;
  final String description;
  bool isFavorite;

  AlbumItem({
    required this.imagePath,
    required this.title,
    required this.description,
    this.isFavorite = false,
  });
}