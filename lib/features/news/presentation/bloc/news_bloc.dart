import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yb_news/features/news/domain/repositories/news_repository.dart';
import 'package:yb_news/features/news/presentation/bloc/news_event.dart';
import 'package:yb_news/features/news/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _repository;

  NewsBloc({required NewsRepository repository})
    : _repository = repository,
      super(NewsInitial()) {
    on<LoadNews>(_onLoadNews);
    on<SearchNews>(_onSearchNews);
    on<ChangeCategory>(_onChangeCategory);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final articles = await _repository.getTopHeadlines(
        category: event.category,
      );
      emit(NewsLoaded(articles: articles, category: event.category));
    } catch (e) {
      emit(NewsError(message: _getErrorMessage(e), category: event.category));
    }
  }

  Future<void> _onSearchNews(SearchNews event, Emitter<NewsState> emit) async {
    final currentState = state;
    final currentCategory = currentState is NewsLoaded
        ? currentState.category
        : 'general';

    emit(NewsLoading());
    try {
      final articles = await _repository.searchArticles(query: event.query);
      emit(
        NewsLoaded(
          articles: articles,
          category: currentCategory,
          searchQuery: event.query,
        ),
      );
    } catch (e) {
      emit(NewsError(message: _getErrorMessage(e), category: currentCategory));
    }
  }

  Future<void> _onChangeCategory(
    ChangeCategory event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final articles = await _repository.getTopHeadlines(
        category: event.category,
      );
      emit(NewsLoaded(articles: articles, category: event.category));
    } catch (e) {
      emit(NewsError(message: _getErrorMessage(e), category: event.category));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<NewsState> emit,
  ) async {
    final currentState = state;
    final currentCategory = currentState is NewsLoaded
        ? currentState.category
        : 'general';

    add(LoadNews(category: currentCategory));
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('socketexception') ||
        errorString.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }
    if (errorString.contains('403') || errorString.contains('forbidden')) {
      return 'API access denied. Please check API key.';
    }
    if (errorString.contains('429') || errorString.contains('rate limit')) {
      return 'Too many requests. Please try again later.';
    }
    return 'Failed to load news. Please try again.';
  }
}
