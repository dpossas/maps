import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/components/divider.widget.dart';
import 'package:maps/models/spot.dart';

class UserFavoriteSpot extends StatefulWidget {
  @override
  _UserFavoriteSpotState createState() => _UserFavoriteSpotState();
}

class _UserFavoriteSpotState extends State<UserFavoriteSpot> {
  final SpotApi spotApi = SpotApi();
  final firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  List<Spot> favoriteSpots = [];

  @override
  void initState() {
    firebaseAuth.currentUser().then((user) {
      _user = user;
      spotApi.getFavoritesByUserId(user.uid).then((spots) {
        setState(() {
          favoriteSpots = spots;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My Favorite Spots'),
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (context, index){
            final spot = favoriteSpots[index];
            return ListTile(
              title: Text("${spot.name}"),
              subtitle: Text("${spot.location}"),
              trailing: IconButton(
                onPressed: () async {
                  favoriteSpots.remove(spot);
                  await spotApi.removeSpotToFavorite(spot.id, _user.uid);
                  setState((){
                    favoriteSpots = favoriteSpots;
                  });
                },
                icon: Icon(Icons.close),
              ),
            );
          },
          separatorBuilder: (context, index) => DividerWidget(),
          itemCount: favoriteSpots.length
        ),
      ),
    );
  }
}