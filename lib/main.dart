import 'package:flutter/material.dart';
import 'package:weatherapp_viraycarlloyd/screens/current_locationScreen.dart';
import 'package:weatherapp_viraycarlloyd/screens/registerScreen.dart';

void main(List<String> args) {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: currentLocationScreen(),
    );
  }
}
