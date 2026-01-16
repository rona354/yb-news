import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yb_news/features/auth/presentation/pages/login_page.dart';
import 'package:yb_news/features/auth/presentation/pages/register_page.dart';
import 'package:yb_news/features/auth/presentation/pages/otp_page.dart';
import 'package:yb_news/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:yb_news/features/news/presentation/pages/news_list_page.dart';
import 'package:yb_news/features/news/presentation/pages/news_detail_page.dart';
import 'package:yb_news/features/news/presentation/pages/trending_page.dart';
import 'package:yb_news/features/news/presentation/pages/comment_page.dart';
import 'package:yb_news/features/news/presentation/pages/bookmark_page.dart';
import 'package:yb_news/shared/services/session_service.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String newsList = '/news';
  static const String newsDetail = '/news/detail';
  static const String trending = '/trending';
  static const String comments = '/comments';
  static const String bookmarks = '/bookmarks';

  static const List<String> _authRoutes = [
    login,
    register,
    otp,
    forgotPassword,
  ];

  static final GoRouter router = GoRouter(
    initialLocation: login,
    redirect: (context, state) async {
      final isAuthenticated = await SessionService.validateSession();
      final currentPath = state.uri.path;
      final isAuthRoute = _authRoutes.contains(currentPath);

      if (!isAuthenticated && !isAuthRoute) {
        return login;
      }
      if (isAuthenticated &&
          (currentPath == login || currentPath == register)) {
        return newsList;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: otp,
        name: 'otp',
        builder: (context, state) {
          final email = state.extra as String?;
          if (email == null || email.isEmpty) {
            return const _InvalidAccessPage(
              message: 'Email required for OTP verification',
            );
          }
          return OtpPage(email: email);
        },
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: newsList,
        name: 'newsList',
        builder: (context, state) => const NewsListPage(),
      ),
      GoRoute(
        path: trending,
        name: 'trending',
        builder: (context, state) => const TrendingPage(),
      ),
      GoRoute(
        path: comments,
        name: 'comments',
        builder: (context, state) {
          final articleTitle = state.extra as String? ?? '';
          return CommentPage(articleTitle: articleTitle);
        },
      ),
      GoRoute(
        path: bookmarks,
        name: 'bookmarks',
        builder: (context, state) => const BookmarkPage(),
      ),
      GoRoute(
        path: newsDetail,
        name: 'newsDetail',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return NewsDetailPage(
            title: extra?['title'] ?? '',
            imageUrl: extra?['imageUrl'] ?? '',
            content: extra?['content'] ?? '',
            source: extra?['source'] ?? '',
            publishedAt: extra?['publishedAt'] ?? '',
            url: extra?['url'] ?? '',
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.path}')),
    ),
  );
}

class _InvalidAccessPage extends StatelessWidget {
  final String message;

  const _InvalidAccessPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
