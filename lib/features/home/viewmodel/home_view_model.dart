import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/home/repository/home_repository.dart';
import 'package:my_couple_app/features/place/model/place.dart';

class HomeState {
  final List<Place> filteredPlaces;
  final bool isLoading;

  HomeState({
    this.filteredPlaces = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    List<Place>? filteredPlaces,
    bool? isLoading,
  }) {
    return HomeState(
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeViewModel(this._repository) : super(HomeState());

  Future<void> fetchNearestUpcomingPlaces(String coupleId) async {
    state = state.copyWith(isLoading: true);

    final places = await _repository.fetchNearestUpcomingPlaces(coupleId);

    print(places);

    state = state.copyWith(
      filteredPlaces: places,
      isLoading: false,
    );
  }
}