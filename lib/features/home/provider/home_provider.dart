import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_couple_app/features/home/datasource/home_service.dart';
import 'package:my_couple_app/features/home/repository/home_repository.dart';
import 'package:my_couple_app/features/home/viewmodel/home_view_model.dart';

final homeRepositoryProvider = Provider((ref) => HomeRepository(HomeService()));
final homeServiceProvider = Provider((ref) => HomeService());

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return HomeViewModel(repository);
});