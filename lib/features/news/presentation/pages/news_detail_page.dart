import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yb_news/core/config/routes.dart';
import 'package:yb_news/core/config/theme.dart';
import 'package:yb_news/core/utils/date_formatter.dart';
import 'package:yb_news/features/news/domain/entities/article.dart';
import 'package:yb_news/shared/services/bookmark_service.dart';

class NewsDetailPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String content;
  final String source;
  final String publishedAt;
  final String url;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.source,
    required this.publishedAt,
    required this.url,
  });

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await BookmarkService.isBookmarked(widget.url);
    if (mounted) {
      setState(() => _isBookmarked = isBookmarked);
    }
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await BookmarkService.removeBookmark(widget.url);
    } else {
      final article = Article(
        title: widget.title,
        description: '',
        content: widget.content,
        url: widget.url,
        imageUrl: widget.imageUrl,
        publishedAt: widget.publishedAt,
        sourceName: widget.source,
        sourceUrl: '',
      );
      await BookmarkService.addBookmark(article);
    }

    if (mounted) {
      setState(() => _isBookmarked = !_isBookmarked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _openSource(BuildContext context) async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: _toggleBookmark,
              ),
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () =>
                    context.push(AppRoutes.comments, extra: widget.title),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: widget.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppTheme.secondaryButtonBg,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.secondaryButtonBg,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      color: AppTheme.secondaryButtonBg,
                      child: const Icon(
                        Icons.newspaper,
                        size: 64,
                        color: AppTheme.textSecondary,
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.titleActive,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.source,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormatter.full(widget.publishedAt),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppTheme.inputBorder.withAlpha(51)),
                  const SizedBox(height: 16),
                  Text(
                    widget.content.isNotEmpty
                        ? widget.content
                        : 'No content available.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (widget.url.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () => _openSource(context),
                        icon: const Icon(
                          Icons.open_in_new,
                          size: 20,
                          color: AppTheme.primaryColor,
                        ),
                        label: Text(
                          'Read Full Article',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
