import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/bloc/simple_bloc_delegate.dart';
import 'package:flutter_news_app/src/commonWidget/bloc/bloc.dart';
import 'package:flutter_news_app/src/theme/bloc/theme_bloc.dart';
import 'package:flutter_news_app/src/theme/bloc/theme_state.dart';
import 'package:flutter_news_app/src/theme/theme.dart';
import 'package:kbett/src/widgets/bunny_video_player.dart'; // Import BunnyVideoPlayer

void main() {
  BlocObserver observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData apptheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          create: (context) =>
              NewsBloc(repository: Repository())..add(Fetch(type: 'General')),
        ),
        BlocProvider<DetailBloc>(create: (context) => DetailBloc()),
        BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is SelectedTheme) {
            apptheme = state.themeType != ThemeType.Light
                ? AppTheme.lightTheme
                : AppTheme.darkTheme;
          }
          return Builder(
            builder: (context) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: apptheme,
                debugShowCheckedModeBanner: false,
                routes: {
                  ...Routes.getRoute(),
                  '/video': (context) => BunnyVideoPlayer(videoId: 'YOUR_VIDEO_ID'), // Add video player route
                },
              );
            },
          );
        },
      ),
    );
  }
}