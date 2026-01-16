import 'package:yb_news/core/constants/api_constants.dart';
import 'package:yb_news/core/network/api_client.dart';
import 'package:yb_news/features/news/data/models/article_model.dart';

class NewsRemoteDatasource {
  final ApiClient _apiClient;

  NewsRemoteDatasource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<ArticleModel>> getTopHeadlines({
    String category = 'general',
    String lang = 'en',
    int max = 10,
  }) async {
    final response = await _apiClient.get(
      '/top-headlines',
      queryParameters: {
        'category': ApiConstants.getApiCategory(category),
        'lang': lang,
        'max': max,
      },
    );

    final articlesJson = response.data['articles'] as List? ?? [];
    final articles = articlesJson
        .map((json) => ArticleModel.fromJson(json))
        .toList();

    return articles;
  }

  Future<List<ArticleModel>> searchArticles({
    required String query,
    String lang = 'en',
    int max = 10,
  }) async {
    final response = await _apiClient.get(
      '/search',
      queryParameters: {'q': query, 'lang': lang, 'max': max},
    );

    final articlesJson = response.data['articles'] as List? ?? [];
    final articles = articlesJson
        .map((json) => ArticleModel.fromJson(json))
        .toList();

    return articles;
  }
}
