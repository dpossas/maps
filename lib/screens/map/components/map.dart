import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/models/spot.dart';
import 'package:maps/notifier/spot_notifier.dart';
import 'package:maps/screens/map/components/modal.spot.data.dart';
import 'package:provider/provider.dart';

class MapObject extends StatefulWidget {
  @override
  _MapObjectState createState() => _MapObjectState();
}

class _MapObjectState extends State<MapObject> {
  final location = Location();
  GoogleMapController mapController;
  LatLng initialPosition = LatLng(-25.441756, -49.2387933);
  Geoflutterfire geo = Geoflutterfire();

  SpotApi api = SpotApi();
  Set<Marker> markers;

  void _onMapCreated(GoogleMapController controller) async {
    LocationData userPosition = await location.getLocation();
    initialPosition = LatLng(userPosition.latitude, userPosition.longitude);

    print('onMapCreated.getSpots');
    await api.getSpotsNearBy(locationToGeo(userPosition), 5);

    mapController = controller;
    location.onLocationChanged.listen(_onUserLocationChange);
  }

  GeoFirePoint locationToGeo(LocationData locationData) {
    GeoFirePoint point = GeoFirePoint(
      locationData.latitude,
      locationData.longitude,
    );

    return point;
  }

  void _onUserLocationChange(LocationData currentLocation) {
    api.getSpotsNearBy(locationToGeo(currentLocation), 5);
    // api.getSpots();

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 12,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageBloc = Provider.of<PageBloc>(context);

    return Consumer<SpotNotifier>(
      builder: (BuildContext context, SpotNotifier notifier, Widget child) {
        return GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 12,
          ),
          onCameraMove: (CameraPosition pos) {
            api.getSpotsNearBy(
                GeoFirePoint(pos.target.latitude, pos.target.longitude), 5);
            pageBloc.setMarkerPosition(pos.target); 
          },
          onLongPress: (LatLng pos) {
            pageBloc.setMarkerPosition(pos);
            pageBloc.changePage(PageState.FORM);
          },
          onTap: (LatLng clickedPosition) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            pageBloc.changePage(PageState.MAP);
          },
          markers: _createMarker(notifier.spotList),
        );
      },
    );
  }

  Set<Marker> _createMarker(List<Spot> spotList) {
    PageBloc pageBloc = Provider.of<PageBloc>(context);

    return spotList
        .map((spot) => Marker(
              markerId: MarkerId(spot.id),
              visible: true,
              position: LatLng(
                spot.position['geopoint'].latitude,
                spot.position['geopoint'].longitude,
              ),
              // icon: _markerIcon,
              onTap: () {
                pageBloc.setSpot(spot);
                pageBloc.changePage(PageState.RESUMED);

                showBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ModalSpotData(
                          spot: spot,
                          key: Key("modal-spot-${pageBloc.currentSpot.id}"),
                        ),
                      ),
                    );
                  },
                );
              },
            ))
        .toSet();
  }
}
