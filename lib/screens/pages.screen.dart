import 'package:flutter/material.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/screens/favorite/user.favorite.spot.dart';
import 'package:maps/screens/map/map.screen.dart';
import 'package:maps/screens/user/user.spots.dart';

class PagesScreen extends StatefulWidget {
  @override
  _PagesScreenState createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  final pageBloc = PageBloc();
  double currentPage = 1;
  final pageController = PageController(initialPage: 1);

  void changePage(int page) {
    pageBloc.changePage(PageState.MAP);

    if (Navigator.of(context).canPop()){
      Navigator.of(context).pop();
    }
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
    setState(() {
      currentPage = page.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _pageBloc = PageBloc();

    return Scaffold(
      bottomNavigationBar: StreamBuilder<PageState>(
        initialData: PageState.MAP,
        builder: (context, snapshot) {
          return StreamBuilder<PageState>(
            stream: _pageBloc.pageStream,
            initialData: PageState.MAP,
            builder: (context, snapshot) {
              return Visibility(
                visible: (snapshot.data == PageState.MAP ||
                    pageController.page == 1),
                child: BottomNavigationBar(
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  currentIndex: currentPage.toInt(),
                  onTap: changePage,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star),
                      title: Text(""),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.location_on),
                      title: Text(""),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text(""),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: <Widget>[
            UserFavoriteSpot(),
            MapScreen(),
            UserSpots(),
          ],
        ),
      ),
    );
  }
}
