import 'package:flutter/material.dart';
import 'package:maps/models/spot.dart';

class SpotNotifier with ChangeNotifier {
  static final _instance = SpotNotifier._internal();
  factory SpotNotifier(){
    return _instance;
  }
  
  List<Spot> _spotList = [];
  Spot _currentSpot;

  List<Spot> get spotList => _spotList;
  Spot get currentSpot => _currentSpot;

  set spotList(List<Spot> spotList) {
    _spotList = spotList;
    notifyListeners();
  }

  set currentSpot(Spot spot) {
    _currentSpot = spot;
    notifyListeners();
  }

  SpotNotifier get instance => _instance;
  SpotNotifier._internal();
}