import 'package:yb_news/features/news/domain/entities/article.dart';

abstract class NewsRepository {
  Future<List<Article>> getTopHeadlines({
    String category = 'general',
    String lang = 'en',
    int max = 10,
  });

  Future<List<Article>> searchArticles({
    required String query,
    String lang = 'en',
    int max = 10,
  });
}
