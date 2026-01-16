import 'package:yb_news/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:yb_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:yb_news/features/news/data/datasources/news_remote_datasource.dart';
import 'package:yb_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:yb_news/features/news/domain/repositories/news_repository.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yb_news/features/news/presentation/bloc/news_bloc.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  void registerSingleton<T>(T instance) {
    _services[T] = instance;
  }

  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service $T not registered');
    }
    if (service is Function) {
      return service() as T;
    }
    return service as T;
  }

  bool isRegistered<T>() => _services.containsKey(T);
}

final sl = ServiceLocator();

void configureDependencies() {
  // Datasources
  sl.registerSingleton<AuthLocalDatasource>(AuthLocalDatasource());
  sl.registerSingleton<NewsRemoteDatasource>(NewsRemoteDatasource());

  // Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(datasource: sl.get<AuthLocalDatasource>()),
  );
  sl.registerSingleton<NewsRepository>(
    NewsRepositoryImpl(remoteDatasource: sl.get<NewsRemoteDatasource>()),
  );

  // BLoCs (factories - new instance each time)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(repository: sl.get<AuthRepository>()),
  );
  sl.registerFactory<NewsBloc>(
    () => NewsBloc(repository: sl.get<NewsRepository>()),
  );
}
