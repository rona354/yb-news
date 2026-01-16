import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get gnewsApiKey => dotenv.env['GNEWS_API_KEY'] ?? '';
  static const String gnewsBaseUrl = 'https://gnews.io/api/v4';

  static const List<String> apiCategories = [
    'general',
    'technology',
    'business',
    'entertainment',
    'sports',
    'health',
    'science',
  ];

  static const List<String> displayCategories = [
    'general',
    'technology',
    'business',
    'finance',
    'entertainment',
    'sports',
    'health',
    'science',
  ];

  static const Map<String, String> categoryApiMap = {'finance': 'business'};

  static String getApiCategory(String displayCategory) {
    return categoryApiMap[displayCategory] ?? displayCategory;
  }

  static const Map<String, String> categoryLabels = {
    'general': 'General',
    'technology': 'Technology',
    'business': 'Business',
    'finance': 'Finance',
    'entertainment': 'Entertainment',
    'sports': 'Sports',
    'health': 'Health',
    'science': 'Science',
  };
}
