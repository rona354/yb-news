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
      content: json['content'] ?? json['description'] ?? '',
      url: json['link'] ?? '',
      imageUrl: json['image_url'] ?? '',
      publishedAt: json['pubDate'] ?? '',
      sourceName: json['source_name'] ?? json['source_id'] ?? '',
      sourceUrl: json['source_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'link': url,
      'image_url': imageUrl,
      'pubDate': publishedAt,
      'source_name': sourceName,
      'source_url': sourceUrl,
    };
  }
}
