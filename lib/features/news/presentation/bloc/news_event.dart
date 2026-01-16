import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNews extends NewsEvent {
  final String category;

  const LoadNews({this.category = 'general'});

  @override
  List<Object?> get props => [category];
}

class SearchNews extends NewsEvent {
  final String query;

  const SearchNews({required this.query});

  @override
  List<Object?> get props => [query];
}

class ChangeCategory extends NewsEvent {
  final String category;

  const ChangeCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class ClearSearch extends NewsEvent {}
