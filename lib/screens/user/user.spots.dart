import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/components/divider.widget.dart';
import 'package:maps/models/spot.dart';

class UserSpots extends StatefulWidget {
  @override
  _UserSpotsState createState() => _UserSpotsState();
}

class _UserSpotsState extends State<UserSpots> {
  final SpotApi spotApi = SpotApi();
  final firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  List<Spot> mySpots = [];

  @override
  void initState() {
    firebaseAuth.currentUser().then((user) {
      _user = user;
      spotApi.getSpotsByUserId(_user.uid).then((spots) {
        setState(() {
          mySpots = spots;
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
        title: Text('My Spots'),
      ),
      body: Container(
        child: ListView.separated(
          itemBuilder: (context, index){
            final spot = mySpots[index];
            return ListTile(
              title: Text("${spot.name}"),
              subtitle: Text("${spot.location}"),
              trailing: SizedBox(width: 17,),
            );
          },
          separatorBuilder: (context, index) => DividerWidget(),
          itemCount: mySpots.length
        ),
      ),
    );
  }
}