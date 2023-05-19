import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class mapsScreen extends StatefulWidget {
  const mapsScreen({super.key});

  @override
  State<mapsScreen> createState() => _mapsScreenState();
}

class _mapsScreenState extends State<mapsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  late GoogleMapController _mapController;
  static const LatLng _postiion = LatLng(15.97439, 120.4792667);
  final List<Marker> _markers = [
    const Marker(markerId: MarkerId('initial'), position: _postiion)
  ];

  Future<bool> checkServicePermission() async {
    LocationPermission locationPermission;
    //check service
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          content: const Text(
              'Location Services is disabled. Please enable it in the settings'),
        ),
      );
      return false;
    }
    //check permission
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      //request
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
            content: const Text(
                'Location Permission is denied. You cannot use the app without allowing location permission'),
          ),
        );
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          content: const Text(
              'Location Permission is forever denied. You cannot use the app without allowing location permission'),
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> getCurrentLocation() async {
    //get gps location if the service and permission is ok
    if (!await checkServicePermission()) {
      return;
    }

    Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.best, distanceFilter: 10))
        .listen((position) {
      placeMarker(LatLng(position.latitude, position.longitude));
    });
  }

  void placeMarker(LatLng pos) {
    _markers.add(Marker(
        markerId: MarkerId('${pos.latitude + pos.longitude}'),
        position: pos,
        infoWindow: const InfoWindow(title: 'My Location')));
    CameraPosition cameraPosition = CameraPosition(target: pos, zoom: 15);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                indoorViewEnabled: true,
                onTap: (pos) {
                  print(pos);

                  _markers.add(Marker(
                      markerId: MarkerId('${pos.latitude + pos.longitude}'),
                      position: pos,
                      infoWindow: const InfoWindow(title: 'My Location')));
                  CameraPosition cameraPosition =
                      CameraPosition(target: pos, zoom: 15);
                  _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition));
                  setState(() {});
                },
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: _markers.toSet(),
                initialCameraPosition: const CameraPosition(
                    target: _postiion, zoom: 14, bearing: 0, tilt: 60))));
  }
}
