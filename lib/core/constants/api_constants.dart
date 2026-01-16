import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static const String newsBaseUrl = 'https://newsdata.io/api/1';

  static const List<String> apiCategories = [
    'top',
    'technology',
    'business',
    'entertainment',
    'sports',
    'health',
    'science',
  ];

  static const List<String> displayCategories = [
    'top',
    'technology',
    'business',
    'finance',
    'entertainment',
    'sports',
    'health',
    'science',
  ];

  static const Map<String, String> categoryApiMap = {
    'finance': 'business',
    'general': 'top',
  };

  static String getApiCategory(String displayCategory) {
    return categoryApiMap[displayCategory] ?? displayCategory;
  }

  static const Map<String, String> categoryLabels = {
    'top': 'General',
    'technology': 'Technology',
    'business': 'Business',
    'finance': 'Finance',
    'entertainment': 'Entertainment',
    'sports': 'Sports',
    'health': 'Health',
    'science': 'Science',
  };
}
