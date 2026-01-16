import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String title;
  final String description;
  final String content;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String sourceName;
  final String sourceUrl;

  const Article({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
    required this.sourceUrl,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    content,
    url,
    imageUrl,
    publishedAt,
    sourceName,
    sourceUrl,
  ];
}
