import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SpotRaitingBar extends StatefulWidget {
  final Function onUpdateRating;
  final double raiting;
  final double itemSize;

  const SpotRaitingBar({Key key, this.raiting, this.onUpdateRating, this.itemSize}) : super(key: key);

  @override
  _SpotRaitingBarState createState() => _SpotRaitingBarState();
}

class _SpotRaitingBarState extends State<SpotRaitingBar> {
  @override
  Widget build(BuildContext context) {
    return RatingBar(
      unratedColor: Colors.transparent,
      initialRating: widget.raiting,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
        empty: Icon(
          Icons.star_border,
          color: Color.fromRGBO(16, 21, 154, 1),
        ),
        full: Icon(
          Icons.star,
          color: Color.fromRGBO(16, 21, 154, 1),
        ),
        half: Icon(
          Icons.star,
          color: Color.fromRGBO(16, 21, 154, 0.5),
        ),
      ),
      itemSize: widget.itemSize ?? 15,
      onRatingUpdate: widget.onUpdateRating ?? (raiting) {
        print('Update rating: $raiting}');
      },
    );
  }
}
