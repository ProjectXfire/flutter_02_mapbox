part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState(
      {this.displayManualMarker = false,
      this.places = const [],
      this.searchedPlaces = const []});

  final bool displayManualMarker;
  final List<Feature> places;
  final List<Feature> searchedPlaces;

  copyWith(
      {bool? displayManualMarker,
      List<Feature>? places,
      List<Feature>? searchedPlaces}) {
    return SearchState(
        displayManualMarker: displayManualMarker ?? this.displayManualMarker,
        places: places ?? this.places,
        searchedPlaces: searchedPlaces ?? this.searchedPlaces);
  }

  @override
  List<Object> get props => [displayManualMarker, places, searchedPlaces];
}
