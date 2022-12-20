import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Models
import 'package:flutter_04_map/modules/map/models/_models.dart';
// Providers
import 'package:flutter_04_map/modules/map/blocs/blocs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate() : super(searchFieldLabel: "Search address");

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          final result = SearchResult(cancel: true);
          close(context, result);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity =
        BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;
    searchBloc.getPlacesByQuery(proximity, query);
    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      final places = state.places;
      return ListView.separated(
        itemCount: places.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final place = places[index];
          return ListTile(
            title: Text(place.text,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text(place.placeName, style: const TextStyle(fontSize: 11)),
            leading: const Icon(
              Icons.place_rounded,
              color: Colors.black,
            ),
            onTap: () {
              final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName);
              searchBloc.add(OnNewSearchedPlace(searchedPlace: place));
              close(context, result);
            },
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    return ListView(
      children: [
        ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              color: Colors.black,
            ),
            title: const Text("Set manual location",
                style: TextStyle(color: Colors.black)),
            onTap: () {
              final result = SearchResult(cancel: false, manual: true);
              close(context, result);
            }),
        ...searchBloc.state.searchedPlaces.map((place) => ListTile(
            leading: const Icon(
              Icons.location_on_outlined,
              color: Colors.black,
            ),
            title: Text(place.text,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                Text(place.placeName, style: const TextStyle(fontSize: 11)),
            onTap: () {
              final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName);
              searchBloc.add(OnNewSearchedPlace(searchedPlace: place));
              close(context, result);
            }))
      ],
    );
  }
}
