import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
// Screens
import 'package:flutter_04_map/modules/map/screens/_screens.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
        return state.isAllEnabled ? const MapScreen() : const GPSScreen();
      }),
    );
  }
}
