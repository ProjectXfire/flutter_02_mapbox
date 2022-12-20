import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_04_map/modules/shared/helpers/_helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Models
import 'package:flutter_04_map/modules/map/models/_models.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
// Delegates
import 'package:flutter_04_map/modules/map/delegates/_delegates.dart';

class IsManualSearchActive extends StatelessWidget {
  const IsManualSearchActive({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state.displayManualMarker) return const SizedBox();
      return FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: const _SearchBar());
    });
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 42,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch(
                context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;
            _searchResult(
                searchBloc: searchBloc,
                mapBloc: mapBloc,
                result: result,
                locationBloc: locationBloc,
                context: context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(255, 74, 107, 147),
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            child: const Text(
              "Where do you want to go?",
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  _searchResult(
      {required SearchBloc searchBloc,
      required SearchResult result,
      required LocationBloc locationBloc,
      required MapBloc mapBloc,
      required BuildContext context}) async {
    if (result.cancel) return;
    if (result.manual!) {
      searchBloc.add(OnActiveManualMarkerEvent());
      return;
    }
    final start = locationBloc.state.lastKnownLocation;
    final end = result.position;
    if (start == null || end == null) return;
    final navigator = Navigator.of(context);
    showLoadingMessage(context: context, message: "Calculating route...");
    final route = await searchBloc.getCoorsStartToEnd(start, end);
    if (route != null) {
      mapBloc.drawRoutePolyline(route);
    }
    navigator.pop();
  }
}
