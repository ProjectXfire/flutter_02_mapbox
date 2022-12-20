part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActiveManualMarkerEvent extends SearchEvent {}

class OnDesactiveManualMarkerEvent extends SearchEvent {}

class OnNewPlacesFoundEvent extends SearchEvent {
  final List<Feature> places;

  const OnNewPlacesFoundEvent({required this.places});
}

class OnNewSearchedPlace extends SearchEvent {
  final Feature searchedPlace;

  const OnNewSearchedPlace({required this.searchedPlace});
}
