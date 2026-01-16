import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yb_news/core/config/routes.dart';
import 'package:yb_news/core/config/theme.dart';
import 'package:yb_news/core/di/injection.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yb_news/features/news/presentation/bloc/news_bloc.dart';

class YbNewsApp extends StatelessWidget {
  const YbNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl.get<AuthBloc>()),
        BlocProvider<NewsBloc>(create: (context) => sl.get<NewsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'YB News',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
