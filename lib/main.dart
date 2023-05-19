import 'package:flutter/material.dart';
import 'package:weatherapp_viraycarlloyd/screens/mapsScreen.dart';

void main(List<String> args) {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mapsScreen(),
    );
  }
}
