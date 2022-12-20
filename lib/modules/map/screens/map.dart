import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
// Widgets
import 'package:flutter_04_map/modules/map/widgets/_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc _locationBloc;
  late MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    _locationBloc.clearSubscription();
    _mapBloc.clearMapSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnownLocation == null) {
            return const Center(child: Text("Waiting..."));
          }
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              Map<String, Polyline> polylines = Map.from(mapState.polylines);
              Map<String, Marker> markers = Map.from(mapState.markers);
              if (!mapState.showRoute) {
                polylines.removeWhere((key, value) => key == "myRoute");
              }
              return SingleChildScrollView(
                child: Stack(children: [
                  MapView(
                    initialLocation: locationState.lastKnownLocation!,
                    polylines: polylines.values.toSet(),
                    markers: markers.values.toSet(),
                  ),
                  const IsManualSearchActive(),
                  const ManualMarker()
                ]),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [BtnFollow(), BtnLocation(), BtnPolylines()],
      ),
    );
  }
}
