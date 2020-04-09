import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/components/divider.widget.dart';
import 'package:maps/models/comment.dart';
import 'package:maps/models/spot.dart';
import 'package:maps/components/spot.raiting.bar.dart';

class ModalSpotData extends StatefulWidget {
  final bool resumed;
  final Spot spot;
  final Function callbackOnTap;

  const ModalSpotData(
      {Key key, this.spot, this.resumed = true, this.callbackOnTap})
      : super(key: key);

  @override
  _ModalSpotDataState createState() => _ModalSpotDataState();
}

class _ModalSpotDataState extends State<ModalSpotData> {
  final firebaseAuth = FirebaseAuth.instance;
  SpotApi spotApi = SpotApi();
  PageBloc pageBloc = PageBloc();
  bool _resumed = true;
  bool _favorited = false;
  FirebaseUser _user;
  double rating = 0;

  @override
  void initState() {
    _resumed = widget.resumed;
    firebaseAuth.currentUser().then((user) {
      _user = user;
      spotApi.spotIsFavorited(pageBloc.currentSpot.id, _user.uid).then((f) {
        setState(() {
          _favorited = f;
        });
      });
    });

    _calculateRating();

    super.initState();
  }

  _calculateRating(){
    pageBloc.currentSpot.comments.forEach((Comment comment) {
      rating += comment.rating;
    });

    rating = rating / pageBloc.currentSpot.comments.length;
  }

  void _changeViewType() {
    if (_resumed && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();

      pageBloc.changePage(PageState.DETAILED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: _changeViewType,
          child: Card(
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              // side: BorderSide(color: Colors.red)
            ),
            color: Colors.white,
            elevation: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      widget.spot.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  title: Text("${widget.spot.name}"),
                  subtitle: Text(
                    widget.spot.location,
                  ),
                  trailing: SizedBox(
                    width: 40,
                    height: 40,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.all(0),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(
                          255,
                          112,
                          116,
                          1,
                        ),
                      ),
                      onPressed: () async {
                        if (_favorited) {
                          await spotApi.removeSpotToFavorite(
                              pageBloc.currentSpot.id, _user.uid);
                        } else {
                          await spotApi.addSpotToFavorite(
                              pageBloc.currentSpot.id, _user.uid);
                        }
                        setState(() {
                          _favorited = !_favorited;
                        });
                      },
                      child: Icon(
                        _favorited ? Icons.favorite : Icons.favorite_border,
                        color: Color.fromRGBO(
                          255,
                          112,
                          116,
                          1,
                        ),
                        size: 17,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
                  child: SpotRaitingBar(
                    raiting: rating,
                  ),
                ),
                Visibility(
                  visible: !_resumed,
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 15),
                    children: <Widget>[
                      ListTile(
                        dense: true,
                        title: DetailTitle('Category'),
                        subtitle: DetailSubtitle(pageBloc.currentSpot.category),
                      ),
                      ListTile(
                        dense: true,
                        title: DetailTitle('About'),
                        subtitle: DetailSubtitle(pageBloc.currentSpot.about),
                      ),
                      ListTile(
                        dense: true,
                        title: DetailTitle('Comments'),
                        trailing: SizedBox(
                          width: 40,
                          height: 40,
                          child: OutlineButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(0),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(
                                16,
                                21,
                                154,
                                1,
                              ),
                            ),
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }

                              pageBloc.changePage(PageState.REVIEW);
                            },
                            child: Icon(
                              Icons.insert_comment,
                              color: Color.fromRGBO(
                                16,
                                21,
                                154,
                                1,
                              ),
                              size: 17,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 627,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.spot.comments.length,
                          separatorBuilder: (context, index) => DividerWidget(),
                          itemBuilder: (context, index) {
                            final Comment comment =
                                widget.spot.comments[index];

                            return ListTile(
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    "${comment.username}",
                                    style: TextStyle(
                                      color: Color.fromRGBO(117, 118, 133, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.14,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Color.fromRGBO(16, 21, 154, 1),
                                    size: 15,
                                  ),
                                  Text(
                                    "${comment.rating}",
                                    style: TextStyle(
                                      color: Color.fromRGBO(16, 21, 154, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                '"${comment.review}"',
                                style: TextStyle(
                                  color: Color.fromRGBO(117, 118, 133, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.17,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 17,
                                height: 17,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DetailTitle extends StatelessWidget {
  final String text;

  const DetailTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      style: TextStyle(
        color: Color.fromRGBO(117, 118, 133, 0.6),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.14,
      ),
    );
  }
}

class DetailSubtitle extends StatelessWidget {
  final String text;

  const DetailSubtitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      style: TextStyle(
        color: Color.fromRGBO(117, 118, 133, 1),
        fontSize: 12,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.17,
      ),
    );
  }
}
