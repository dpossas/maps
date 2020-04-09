import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps/api/spot.api.dart';
import 'package:maps/blocs/page.bloc.dart';
import 'package:maps/models/spot.dart';
import 'package:maps/services/firestore.uploader.dart';
import 'package:uuid/uuid.dart';

class SpotFormScreen extends StatefulWidget {
  @override
  _SpotFormScreenState createState() => _SpotFormScreenState();
}

class _SpotFormScreenState extends State<SpotFormScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  bool isPhysicalDevice = false;

  File _imageFile;
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _colorController = TextEditingController();

  final pageBloc = PageBloc();
  SpotApi api = SpotApi();
  Geoflutterfire geo = Geoflutterfire();
  FirebaseUser _user;

  @override
  void initState() {
    firebaseAuth.currentUser().then((user) {
      _user = user;
      loadPlacemark();
      initPlatformState();
    });

    super.initState();
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        await deviceInfoPlugin.androidInfo.then((_) {
          isPhysicalDevice = _.isPhysicalDevice;
        });
      } else if (Platform.isIOS) {
        await deviceInfoPlugin.iosInfo.then((_) {
          isPhysicalDevice = _.isPhysicalDevice;
        });
      }
    } catch (e) {
      print("Error on load device info: $e");
    }

    if (!mounted) return;
  }

  void _pickImage() async {
    File selectedFile = await ImagePicker.pickImage(
        source: isPhysicalDevice ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      _imageFile = selectedFile;
    });
  }

  void loadPlacemark() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        pageBloc.markerPosition.latitude, pageBloc.markerPosition.longitude);
    if (placemark != null && placemark.isNotEmpty) {
      final pos = placemark.first;
      setState(() {
        _locationController.text =
            "${pos.subLocality}, ${pos.locality}, ${pos.country}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 30,
            height: 150,
            color: Color.fromRGBO(216, 216, 216, 1),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: _imageFile == null
                  ? IconButton(
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Color.fromRGBO(16, 21, 154, 1),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(_imageFile.path),
                              fit: BoxFit.cover)),
                    ),
            ),
          ),
          _formTextField(labelText: 'Name', controller: _nameController),
          _formTextField(
              labelText: 'Categories', controller: _categoryController),
          _formTextField(
            labelText: 'Location',
            controller: _locationController,
            suffixIcon: Icon(
              Icons.location_on,
              color: Color.fromRGBO(16, 21, 154, 1),
              size: 22,
            ),
          ),
          _formTextField(
            labelText: 'Pin Color',
            controller: _colorController,
            suffixIcon: Icon(
              Icons.color_lens,
              color: Color.fromRGBO(16, 21, 154, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 20.0, right: 20, left: 20),
            child: RaisedButton(
              onPressed: () async {
                final uploader = FirestoreUploader(
                  _imageFile,
                );
                String image = await uploader.startUpload();
                api.addSpots(
                  spot: Spot(
                    Uuid().v1(),
                    '${_nameController.text}',
                    '',
                    '${_categoryController.text}',
                    '${_locationController.text}',
                    '${_colorController.text}',
                    '$image',
                    [],
                    geo
                        .point(latitude: pageBloc.markerPosition.latitude, longitude: pageBloc.markerPosition.longitude)
                        .data,
                    _user.uid,
                  ),
                );
                pageBloc.changePage(PageState.MAP);
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
                  'Add Spot',
                  style: TextStyle(
                    fontFamily: "Nunito",
                    fontSize: 16,
                    color: Color.fromRGBO(16, 21, 154, 1),
                    letterSpacing: 0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formTextField(
      {String labelText, TextEditingController controller, Icon suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: Color.fromRGBO(17, 18, 54, 1),
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: "Nunito",
        ),
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          suffix: suffixIcon ?? null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color: Color.fromRGBO(117, 118, 133, 0.6),
              style: BorderStyle.solid,
            ),
          ),
          labelText: "$labelText",
          labelStyle: TextStyle(
            color: Color.fromRGBO(117, 118, 133, 0.6),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          alignLabelWithHint: false,
        ),
        maxLines: 1,
      ),
    );
  }
}
