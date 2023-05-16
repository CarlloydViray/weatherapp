import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';

class currentLocationScreen extends StatefulWidget {
  const currentLocationScreen({super.key});

  @override
  State<currentLocationScreen> createState() => _currentLocationScreenState();
}

class _currentLocationScreenState extends State<currentLocationScreen> {
  Position? currentPosition;

  Future<bool> checkServicePermission() async {
    LocationPermission locationPermission;
    //check service
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          content: Text(
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
            content: Text(
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
          content: Text(
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

    await Geolocator.getCurrentPosition().then((position) {
      print(position);
      setState(() {
        currentPosition = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('GPS Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: ${currentPosition?.latitude ?? ''}'),
            Text('Longitude: ${currentPosition?.longitude ?? ''}'),
            ElevatedButton(
                onPressed: getCurrentLocation,
                child: Text('Get Current Location'))
          ],
        ),
      ),
    ));
  }
}
