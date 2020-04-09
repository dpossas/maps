import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/models/spot.dart';
import 'package:rxdart/rxdart.dart';

enum PageState {
  MAP,
  RESUMED,
  DETAILED,
  SEARCHING,
  FORM,
  REVIEW,
}

class PageBloc {
  static final PageBloc _instance = PageBloc._internal();
  final SpotApi api = SpotApi();

  factory PageBloc() {
    return _instance;
  }

  BehaviorSubject _screenController = BehaviorSubject<PageState>();
  Stream get pageStream => _screenController.stream;
  Spot _currentSpot;
  LatLng _newMarkerPosition;

  void changePage(PageState page) {
    _screenController.sink.add(page);
  }

  Future<bool> commentSpot() async {
    
    return false;
  }

  void setSpot(Spot spot) {
    this._currentSpot = spot;
  }
  Spot get currentSpot => _currentSpot;

  void setMarkerPosition(LatLng position){
    this._newMarkerPosition = position;
  }
  LatLng get markerPosition => _newMarkerPosition;

  PageBloc get instance => _instance;
  PageBloc._internal();
}