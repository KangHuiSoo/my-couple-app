import 'package:my_couple_app/features/home/datasource/home_service.dart';
import 'package:my_couple_app/features/place/model/place.dart';

class HomeRepository {
  final HomeService homeService;

  HomeRepository(this.homeService);


  /** 다가오는 가까운 날짜의 장소데이터 조회 **/
  Future<List<Place>> fetchNearestUpcomingPlaces(String coupleId) async {
    return homeService.fetchNearestUpcomingPlaces(coupleId);
  }
}