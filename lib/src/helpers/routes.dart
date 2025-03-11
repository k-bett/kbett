import 'package:flutter/material.dart';
import 'package:flutter_news_app/src/pages/category/categoryPage.dart';
import 'package:flutter_news_app/src/pages/homePage/homePage.dart';
import 'package:flutter_news_app/src/pages/newsApp.dart';
import 'package:flutter_news_app/src/pages/newsDetail/newsDetailPage.dart';
import 'package:flutter_news_app/src/pages/profile/profilePage.dart';
import 'package:kbett/src/widgets/bunny_video_player.dart'; // Import BunnyVideoPlayer

class Routes{
  static Map<String,WidgetBuilder> getRoute(){
    return  <String, WidgetBuilder>{
          '/': (_) => NewsApp(),
          '/home': (_) => HomePage(),
          '/detail': (_) => NewsDetailPage(),
          '/category': (_) => CategoryPage(),
          '/profile': (_) => ProfilePage(),
          '/video': (_) => BunnyVideoPlayer(videoId: 'YOUR_VIDEO_ID'), // Add video player route
        };
  }
}