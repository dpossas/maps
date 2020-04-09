import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/components/spot.raiting.bar.dart';
import 'package:maps/models/comment.dart';
import 'package:maps/models/spot.dart';

class CommentScreen extends StatefulWidget {
  final Spot spot;

  const CommentScreen({Key key, this.spot}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final pageBloc = PageBloc();
  final reviewController = TextEditingController();
  final firebaseAuth = FirebaseAuth.instance;
  final api = SpotApi();
  double rating = 5;

  FirebaseUser _user;

  @override
  void initState() {
    firebaseAuth.currentUser().then((user) {
      _user = user;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "New Review",
            style: TextStyle(
              color: Color.fromRGBO(117, 118, 133, 0.6),
              fontSize: 14,
              letterSpacing: 0.17,
            ),
          ),
          Container(
            height: 80,
            child: Center(
              child: SpotRaitingBar(
                onUpdateRating: (newRating) {
                  setState((){
                    rating = newRating;
                  });
                },
                raiting: rating,
                itemSize: 30,
              ),
            ),
          ),
          TextFormField(
            style: TextStyle(
              color: Color.fromRGBO(17, 18, 54, 1),
              fontSize: 14,
              fontWeight: FontWeight.normal,
              fontFamily: "Nunito",
            ),
            controller: reviewController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Color.fromRGBO(117, 118, 133, 0.6),
                  style: BorderStyle.solid,
                ),
              ),
              labelText: "Comment",
              labelStyle: TextStyle(
                color: Color.fromRGBO(117, 118, 133, 0.6),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              alignLabelWithHint: false,
            ),
            maxLines: 4,
          ),
          SizedBox(
            height: 25,
          ),
          RaisedButton(
            onPressed: () async {
              final spot = pageBloc.currentSpot;
              final comment = Comment(_user.displayName, reviewController.text, rating.toInt());
              spot.comments.add(comment);

              await api.upadteSpot(spot);

              pageBloc.changePage(PageState.DETAILED);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            color: Color.fromRGBO(255, 190, 0, 1),
            child: Center(
              child: Text(
                'Comment',
                style: TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 16,
                  color: Color.fromRGBO(16, 21, 154, 1),
                  letterSpacing: 0,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
