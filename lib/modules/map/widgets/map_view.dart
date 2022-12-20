import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';

class MapView extends StatelessWidget {
  const MapView({
    Key? key,
    required this.initialLocation,
    required this.polylines,
    required this.markers,
  }) : super(key: key);

  final LatLng initialLocation;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    final initialCameraPosition =
        CameraPosition(target: initialLocation, zoom: 15);
    final size = MediaQuery.of(context).size;
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (event) {
          mapBloc.add(const OnToggleFollowingUserEvent(toggleValue: false));
        },
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          polylines: polylines,
          markers: markers,
          onMapCreated: (controller) =>
              mapBloc.add(OnMapInitializedMap(controller)),
          onCameraMove: (position) => mapBloc.mapCenter = position.target,
          //
        ),
      ),
    );
  }
}
