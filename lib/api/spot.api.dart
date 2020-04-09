import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:maps/models/favorite.dart';
import 'package:maps/models/spot.dart';
import 'package:maps/notifier/spot_notifier.dart';
import 'package:meta/meta.dart';

class SpotApi {
  final Firestore _db = Firestore.instance;
  static final SpotApi _instance = SpotApi._internal();
  final SpotNotifier notifier = SpotNotifier();
  CollectionReference _spotRef;
  CollectionReference _favRef;

  factory SpotApi() {
    return _instance;
  }

  static documentsToSpotList(List<DocumentSnapshot> documents) {
    List<Spot> _spotList = [];

    documents.forEach((spotDocument) {
      Spot spot = Spot.fromJson(spotDocument.data);
      _spotList.add(spot);
    });

    return _spotList;
  }

  _setSpotList(List<DocumentSnapshot> documents) {
    notifier.spotList = SpotApi.documentsToSpotList(documents);
  }

  getSpotsNearBy(GeoFirePoint center, double kilometers) async {
    Geoflutterfire geo = Geoflutterfire();
    print(
        "Posição do usuário: https://www.google.com/maps/@${center.geoPoint.latitude},${center.geoPoint.longitude},15z");

    geo
        .collection(collectionRef: Firestore.instance.collection('spots'))
        .within(
          center: center,
          radius: 5,
          field: 'position',
          strictMode: true,
        )
        .listen(_setSpotList);
  }

  addSpots({@required Spot spot}) async {
    _spotRef.add(spot.toJson());
  }

  Future<void> upadteSpot(Spot spot) async {
    QuerySnapshot snapshot =
        await _spotRef.where('id', isEqualTo: spot.id).getDocuments();

    DocumentSnapshot document = snapshot.documents.single;
    return _spotRef.document(document.documentID).updateData(spot.toJson());
  }

  searchByName(String q) async {
    QuerySnapshot snapshot = await _spotRef
        .where(
          'name',
          isGreaterThanOrEqualTo: q,
        )
        .orderBy('name')
        .getDocuments();
    snapshot.documents.forEach((f) {
      print(f.data);
    });
    return SpotApi.documentsToSpotList(snapshot.documents);
  }

  getSpotsByUserId(String userId) async {
    List<Spot> spots = [];
    QuerySnapshot snapshot = await _spotRef.where('userId', isEqualTo: userId).getDocuments();
    if (snapshot.documents != null && snapshot.documents.isNotEmpty){
      snapshot.documents.forEach((document){
        spots.add(Spot.fromJson(document.data));
      });
    }

    return spots;
  }

  addSpotToFavorite(String spotId, String userId) async {
    _favRef.add(Favorite(spotId, userId).toJson());
  }

  removeSpotToFavorite(String spotId, String userId) async {
    DocumentSnapshot document = await getFavorited(spotId, userId);
    if (document != null) {
      await _favRef.document(document.documentID).delete();
    }
  }

  Future<bool> spotIsFavorited(String spotId, String userId) async {
    DocumentSnapshot document = await getFavorited(spotId, userId);
    return document != null;
  }

  Future<DocumentSnapshot> getFavorited(String spotId, String userId) async {
    try {
      return (await _favRef
              .where('spotId', isEqualTo: spotId)
              .where('userId', isEqualTo: userId)
              .getDocuments())
          .documents
          ?.single;
    } catch (e) {
      return null;
    }
  }

  Future<List<Spot>> getFavoritesByUserId(String userId) async {
    List<Spot> spots = [];
    QuerySnapshot snapshot = await _favRef.where('userId', isEqualTo: userId).getDocuments();
    List<String> spotIds = [];

    if ( snapshot.documents != null && snapshot.documents.isNotEmpty ){
      snapshot.documents.forEach((document) {
        spotIds.add(document.data['spotId']);
      });

      QuerySnapshot dSnapshot = await _spotRef.where('id', whereIn: spotIds).getDocuments();
      dSnapshot.documents.forEach((d) {
        spots.add(Spot.fromJson(d.data));
      });
    }

    return spots;
  }

  SpotApi get instance => _instance;
  SpotApi._internal() {
    _spotRef = _db.collection('spots');
    _favRef = _db.collection('favorites');
  }
}
