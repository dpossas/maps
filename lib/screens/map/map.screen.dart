import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/components/modal/modal.closeable.dart';
import 'package:maps/models/comment.dart';
import 'package:maps/models/spot.dart';
import 'package:maps/screens/comment/comment.screen.dart';
import 'package:maps/screens/map/components/map.dart';
import 'package:maps/screens/map/components/modal.spot.data.dart';
import 'package:maps/screens/map/components/search.bar.dart';
import 'package:maps/screens/spot/spot.form.screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  void initState() {
    firebaseAuth.currentUser().then((user) {
      _user = user;

      //fakeData();
    });
    super.initState();
  }

  void fakeData() async {
    Geoflutterfire geo = Geoflutterfire();

    Spot jardimBotanico = Spot(
      Uuid().v1(),
      'Jardim Botânico',
      'Parque fundado em 1991, com uma estufa, um jardim formal no estilo francês e um jardim de sensações.',
      'Park',
      'Cristo Rei, Curitiba, Brazil',
      '#FF7074',
      'https://www.ademilar.com.br/blog/wp-content/uploads/2018/02/conheca-o-jardim-botanico-de-curitiba-ademilar.jpg',
      [
        Comment(
          'Rubens Jr.',
          'Adorei o jardim botânico, ótimo lugar para passear com sua família.',
          5,
        ),
        Comment(
          'Johnny Santos',
          'Muito bom',
          5,
        )
      ],
      geo.point(latitude: -25.441756, longitude: -49.2387933).data,
      _user.uid,
    );

    await Firestore.instance
        .collection('spots')
        .document()
        .setData(jardimBotanico.toJson());

    Spot parqueSaoJose = Spot(
      Uuid().v1(),
      'Parque São José',
      'Parque para caminhada, lazer, lagos, espaço para churrasco (quiosques).',
      'Park',
      'São José dos Pinhais',
      '#FF9900',
      'https://lh5.googleusercontent.com/p/AF1QipMpswLh16f0DrFkwV9Ak3987IfPGtlFsMdo7mJS=w408-h271-k-no',
      [
        Comment(
          'Douglas Possas',
          'Muito bom o ambiente, mas o banheiro deixa a desejar',
          4,
        )
      ],
      geo.point(latitude: -25.5116355, longitude: -49.2096028).data,
      _user.uid,
    );

    await Firestore.instance
        .collection('spots')
        .document()
        .setData(parqueSaoJose.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final pageBloc = Provider.of<PageBloc>(context);

    return Stack(
      children: <Widget>[
        MapObject(),
        StreamBuilder<PageState>(
          initialData: PageState.MAP,
          stream: pageBloc.pageStream,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              map:
              case PageState.MAP:
                return Positioned(
                  left: 15,
                  right: 15,
                  top: 20,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            SearchBar(
                              addFunction: () {
                                pageBloc.changePage(PageState.FORM);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
                break;
              case PageState.RESUMED:
                continue map;
                break;
              case PageState.DETAILED:
                return ModalCloseable(
                  child: Container(
                    padding: EdgeInsets.all(0),
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
                    child: ModalSpotData(
                      spot: pageBloc.currentSpot,
                      resumed: false,
                      key: Key("modal-spot-${pageBloc.currentSpot.id}"),
                    ),
                  ),
                );
                break;
              case PageState.SEARCHING:
                continue map;
                break;
              case PageState.FORM:
                return ModalCloseable(
                  child: SpotFormScreen(),
                );
                break;
              case PageState.REVIEW:
                return ModalCloseable(
                  child: CommentScreen(
                    spot: pageBloc.currentSpot,
                  ),
                );
                break;
              default:
                continue map;
            }
          },
        ),
      ],
    );
  }
}
