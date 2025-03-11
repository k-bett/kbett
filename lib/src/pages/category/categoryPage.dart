import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/commonWidget/bloc/bloc.dart';
import 'package:flutter_news_app/src/commonWidget/customWidget.dart';
import 'package:flutter_news_app/src/pages/homePage/bloc/bloc.dart';
import 'package:flutter_news_app/src/theme/theme.dart';

class CategoryPage extends StatefulWidget {
  final PageController controller;
  CategoryPage({Key key, this.controller}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Widget _categoryCard(String text, String type, String imgPath) {
    return InkWell(
      onTap: () {
        // Update the type based on the new categories if needed
        BlocProvider.of<NewsBloc>(context).add(Fetch(type: type));
        BlocProvider.of<NavigationBloc>(context).add(Navigate(pageIndex: 0));

        widget.controller.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: customImage(imgPath, fit: BoxFit.cover),
            ),
          ),
          Text(
            text,
            style: AppTheme.h2Style.copyWith(
                color: Theme.of(context).colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        title: Text(
          'Categories',
          style: AppTheme.h2Style.copyWith(color: Theme.of(context).primaryColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: GridView.count(
          padding: EdgeInsets.symmetric(vertical: 20),
          childAspectRatio: .8,
          mainAxisSpacing: 20,
          crossAxisSpacing: 0,
          crossAxisCount: 3,
          children: <Widget>[
            _categoryCard('Movies', 'movies',
                'https://example.com/images/movies.jpg'),
            _categoryCard('TV Shows', 'tvshows',
                'https://example.com/images/tvshows.jpg'),
            _categoryCard('Podcasts', 'podcasts',
                'https://example.com/images/podcasts.jpg'),
            _categoryCard('From Kitchen', 'kitchen',
                'https://example.com/images/kitchen.jpg'),
          ],
        ),
      ),
    );
  }
}