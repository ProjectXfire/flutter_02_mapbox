import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Helpers
import 'package:flutter_04_map/modules/shared/helpers/_helpers.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      return state.displayManualMarker
          ? const _ManualMarkerBody()
          : const SizedBox();
    });
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            const Positioned(top: 70, left: 20, child: _BtnBack()),
            Center(
                child: Transform.translate(
              offset: const Offset(0, -18),
              child: BounceInDown(
                  from: 100,
                  child: const Icon(Icons.location_on_rounded,
                      size: 50, color: Colors.red)),
            )),
            Positioned(
                bottom: 70,
                left: 40,
                child: FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: MaterialButton(
                    height: 50,
                    minWidth: size.width - 120,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    color: Colors.white,
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final start = locationBloc.state.lastKnownLocation;
                      final end = mapBloc.mapCenter;
                      if (start == null || end == null) return;
                      searchBloc.add(OnDesactiveManualMarkerEvent());
                      showLoadingMessage(
                          context: context, message: "Calculating route...");
                      final route =
                          await searchBloc.getCoorsStartToEnd(start, end);
                      if (route != null) {
                        mapBloc.drawRoutePolyline(route);
                      }
                      navigator.pop();
                    },
                    child: const Text("Confirm destination"),
                  ),
                ))
          ],
        ));
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);

    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
              onPressed: () {
                searchBloc.add(OnDesactiveManualMarkerEvent());
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ))),
    );
  }
}
