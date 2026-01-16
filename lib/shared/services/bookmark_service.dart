import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yb_news/features/news/domain/entities/article.dart';

class BookmarkService {
  static const _bookmarksKey = 'bookmarks';

  static Future<List<Article>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_bookmarksKey);

    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => _articleFromJson(json)).toList();
  }

  static Future<void> addBookmark(Article article) async {
    final bookmarks = await getBookmarks();

    if (bookmarks.any((b) => b.url == article.url)) return;

    bookmarks.insert(0, article);
    await _saveBookmarks(bookmarks);
  }

  static Future<void> removeBookmark(String url) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b.url == url);
    await _saveBookmarks(bookmarks);
  }

  static Future<bool> isBookmarked(String url) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b.url == url);
  }

  static Future<void> _saveBookmarks(List<Article> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = bookmarks.map((a) => _articleToJson(a)).toList();
    await prefs.setString(_bookmarksKey, jsonEncode(jsonList));
  }

  static Map<String, dynamic> _articleToJson(Article article) {
    return {
      'title': article.title,
      'description': article.description,
      'content': article.content,
      'url': article.url,
      'imageUrl': article.imageUrl,
      'publishedAt': article.publishedAt,
      'sourceName': article.sourceName,
      'sourceUrl': article.sourceUrl,
    };
  }

  static Article _articleFromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      sourceName: json['sourceName'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
    );
  }
}
