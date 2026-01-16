import 'package:yb_news/core/constants/api_constants.dart';
import 'package:yb_news/core/network/api_client.dart';
import 'package:yb_news/features/news/data/models/article_model.dart';

class NewsRemoteDatasource {
  final ApiClient _apiClient;

  NewsRemoteDatasource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<ArticleModel>> getTopHeadlines({
    String category = 'top',
    String language = 'en',
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/news',
      queryParameters: {
        'category': ApiConstants.getApiCategory(category),
        'language': language,
        'size': size,
      },
    );

    final articlesJson = response.data['results'] as List? ?? [];
    final articles = articlesJson
        .map((json) => ArticleModel.fromJson(json))
        .toList();

    return articles;
  }

  Future<List<ArticleModel>> searchArticles({
    required String query,
    String language = 'en',
    int size = 10,
  }) async {
    final response = await _apiClient.get(
      '/news',
      queryParameters: {
        'q': query,
        'language': language,
        'size': size,
      },
    );

    final articlesJson = response.data['results'] as List? ?? [];
    final articles = articlesJson
        .map((json) => ArticleModel.fromJson(json))
        .toList();

    return articles;
  }
}
