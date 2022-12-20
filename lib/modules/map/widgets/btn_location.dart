import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
// Widgets
import 'package:flutter_04_map/modules/shared/widgets/_widgets.dart';

class BtnLocation extends StatelessWidget {
  const BtnLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
          maxRadius: 25,
          child: IconButton(
            onPressed: () {
              final userLocation = locationBloc.state.lastKnownLocation;
              if (userLocation == null) {
                final snackbar = CustomSnackbar(
                  message: "No found location",
                  duration: const Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                return;
              }
              mapBloc.moveCamera(userLocation);
            },
            icon: const Icon(Icons.my_location_outlined),
          )),
    );
  }
}
