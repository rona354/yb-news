import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yb_news/core/config/theme.dart';
import 'package:yb_news/core/utils/date_formatter.dart';
import 'package:yb_news/core/config/routes.dart';
import 'package:yb_news/features/news/presentation/bloc/news_bloc.dart';
import 'package:yb_news/features/news/presentation/bloc/news_state.dart';
import 'package:yb_news/features/news/domain/entities/article.dart';
import 'package:yb_news/shared/widgets/loading_widget.dart';
import 'package:yb_news/shared/widgets/error_widget.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Trending',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "See what's popular right now",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const NewsListShimmer();
                  }

                  if (state is NewsError) {
                    return AppErrorWidget(
                      message: state.message,
                      onRetry: () => context.pop(),
                    );
                  }

                  if (state is NewsLoaded) {
                    final articles = state.articles.take(10).toList();

                    if (articles.isEmpty) {
                      return Center(
                        child: Text(
                          'No trending articles',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: articles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _TrendingArticleCard(
                          article: articles[index],
                          rank: index + 1,
                          onTap: () {
                            context.push(
                              AppRoutes.newsDetail,
                              extra: {
                                'title': articles[index].title,
                                'imageUrl': articles[index].imageUrl,
                                'content': articles[index].content,
                                'source': articles[index].sourceName,
                                'publishedAt': articles[index].publishedAt,
                                'url': articles[index].url,
                              },
                            );
                          },
                        );
                      },
                    );
                  }

                  return const NewsListShimmer();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingArticleCard extends StatelessWidget {
  final Article article;
  final int rank;
  final VoidCallback onTap;

  const _TrendingArticleCard({
    required this.article,
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 80,
              height: 80,
              child: article.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.secondaryButtonBg,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.secondaryButtonBg,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      color: AppTheme.secondaryButtonBg,
                      child: const Icon(
                        Icons.newspaper,
                        color: AppTheme.textSecondary,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.titleActive,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        article.sourceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Text(
                      ' · ',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      DateFormatter.short(article.publishedAt),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
