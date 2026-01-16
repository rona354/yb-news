import 'package:equatable/equatable.dart';
import 'package:yb_news/features/news/domain/entities/article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final String category;
  final String? searchQuery;

  const NewsLoaded({
    required this.articles,
    required this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [articles, category, searchQuery];

  NewsLoaded copyWith({
    List<Article>? articles,
    String? category,
    String? searchQuery,
  }) {
    return NewsLoaded(
      articles: articles ?? this.articles,
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NewsError extends NewsState {
  final String message;
  final String category;

  const NewsError({required this.message, this.category = 'general'});

  @override
  List<Object?> get props => [message, category];
}
