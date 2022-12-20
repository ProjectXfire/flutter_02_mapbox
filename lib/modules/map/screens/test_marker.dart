import 'package:flutter/material.dart';
// Markers
import 'package:flutter_04_map/modules/map/markers/_markers.dart';

class TestMarkerScreen extends StatelessWidget {
  const TestMarkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 350,
          height: 150,
          child: CustomPaint(
            painter: EndMarker(
                destination: "El pepe buscando cosas", kilometers: 58),
          ),
        ),
      ),
    );
  }
}
