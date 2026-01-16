import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_news/core/config/routes.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_event.dart';
import 'package:yb_news/features/news/presentation/bloc/news_bloc.dart';
import 'package:yb_news/features/news/presentation/bloc/news_event.dart';
import 'package:yb_news/features/news/presentation/bloc/news_state.dart';
import 'package:yb_news/features/news/presentation/widgets/article_card.dart';
import 'package:yb_news/features/news/presentation/widgets/category_chips.dart';
import 'package:yb_news/features/news/presentation/widgets/search_bar.dart';
import 'package:yb_news/shared/widgets/error_widget.dart';
import 'package:yb_news/shared/widgets/loading_widget.dart';
import 'package:yb_news/shared/widgets/offline_banner.dart';
import 'package:yb_news/shared/services/connectivity_service.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(const LoadNews());
    _checkConnectivity();
    _listenToConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnection();
    setState(() {
      _isOffline = !isConnected;
    });
  }

  void _listenToConnectivity() {
    final newsBloc = context.read<NewsBloc>();
    _connectivitySubscription = _connectivityService.connectionStatus.listen((
      isConnected,
    ) {
      if (!mounted) return;
      final wasOffline = _isOffline;
      setState(() {
        _isOffline = !isConnected;
      });
      if (isConnected && wasOffline) {
        final state = newsBloc.state;
        if (state is NewsLoaded) {
          if (state.searchQuery != null) {
            newsBloc.add(SearchNews(query: state.searchQuery!));
          } else {
            newsBloc.add(LoadNews(category: state.category));
          }
        } else if (state is NewsError) {
          newsBloc.add(LoadNews(category: state.category));
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityService.dispose();
    super.dispose();
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
              context.go(AppRoutes.login);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YB News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.trending_up),
            onPressed: () => context.push(AppRoutes.trending),
            tooltip: 'Trending',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => context.push(AppRoutes.bookmarks),
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isOffline) const OfflineBanner(),
          const SizedBox(height: 12),
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              final currentQuery = state is NewsLoaded
                  ? state.searchQuery
                  : null;
              return NewsSearchBar(
                currentQuery: currentQuery,
                onSearch: (query) {
                  context.read<NewsBloc>().add(SearchNews(query: query));
                },
                onClear: () {
                  context.read<NewsBloc>().add(ClearSearch());
                },
              );
            },
          ),
          const SizedBox(height: 12),
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              final selectedCategory = state is NewsLoaded
                  ? state.category
                  : state is NewsError
                  ? state.category
                  : 'general';
              return CategoryChips(
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  context.read<NewsBloc>().add(
                    ChangeCategory(category: category),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const NewsListShimmer();
                }

                if (state is NewsError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<NewsBloc>().add(
                        LoadNews(category: state.category),
                      );
                    },
                  );
                }

                if (state is NewsLoaded) {
                  if (state.articles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.searchQuery != null
                                ? 'No results for "${state.searchQuery}"'
                                : 'No articles found',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      if (state.searchQuery != null) {
                        context.read<NewsBloc>().add(
                          SearchNews(query: state.searchQuery!),
                        );
                      } else {
                        context.read<NewsBloc>().add(
                          LoadNews(category: state.category),
                        );
                      }
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWideScreen = constraints.maxWidth >= 600;
                        final crossAxisCount = constraints.maxWidth >= 900
                            ? 3
                            : 2;

                        if (isWideScreen) {
                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                            itemCount: state.articles.length,
                            itemBuilder: (context, index) {
                              final article = state.articles[index];
                              return ArticleCard(
                                article: article,
                                onTap: () {
                                  context.push(
                                    AppRoutes.newsDetail,
                                    extra: {
                                      'title': article.title,
                                      'imageUrl': article.imageUrl,
                                      'content': article.content,
                                      'source': article.sourceName,
                                      'publishedAt': article.publishedAt,
                                      'url': article.url,
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.articles.length,
                          itemBuilder: (context, index) {
                            final article = state.articles[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ArticleCard(
                                article: article,
                                onTap: () {
                                  context.push(
                                    AppRoutes.newsDetail,
                                    extra: {
                                      'title': article.title,
                                      'imageUrl': article.imageUrl,
                                      'content': article.content,
                                      'source': article.sourceName,
                                      'publishedAt': article.publishedAt,
                                      'url': article.url,
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const NewsListShimmer();
              },
            ),
          ),
        ],
      ),
    );
  }
}
