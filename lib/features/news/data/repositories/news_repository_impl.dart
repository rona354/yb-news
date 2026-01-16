import 'package:yb_news/features/news/data/datasources/news_remote_datasource.dart';
import 'package:yb_news/features/news/domain/entities/article.dart';
import 'package:yb_news/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource _remoteDatasource;

  NewsRepositoryImpl({NewsRemoteDatasource? remoteDatasource})
    : _remoteDatasource = remoteDatasource ?? NewsRemoteDatasource();

  @override
  Future<List<Article>> getTopHeadlines({
    String category = 'top',
    String lang = 'en',
    int max = 10,
  }) async {
    return _remoteDatasource.getTopHeadlines(
      category: category,
      language: lang,
      size: max,
    );
  }

  @override
  Future<List<Article>> searchArticles({
    required String query,
    String lang = 'en',
    int max = 10,
  }) async {
    return _remoteDatasource.searchArticles(query: query, language: lang, size: max);
  }
}
