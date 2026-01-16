import 'package:yb_news/features/news/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.content,
    required super.url,
    required super.imageUrl,
    required super.publishedAt,
    required super.sourceName,
    required super.sourceUrl,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['image'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      sourceUrl: json['source']?['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'image': imageUrl,
      'publishedAt': publishedAt,
      'source': {'name': sourceName, 'url': sourceUrl},
    };
  }
}
