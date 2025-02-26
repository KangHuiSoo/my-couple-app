import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
import 'package:my_couple_app/data/model/place/place_keyword_request.dart';
import 'package:my_couple_app/data/provider/notifier/place_notifier.dart';
import 'package:my_couple_app/data/provider/place/place_provider.dart';

import '../../data/model/place/place.dart';
import '../../data/model/place/place_response.dart';

class PlaceSearchScreen extends ConsumerStatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
  TextEditingController searchController = TextEditingController();
  PlaceKeywordRequest? request;

  @override
  Widget build(BuildContext context) {
    final placeAsyncValue = ref.watch(placeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          GoRouter.of(context).go('/placeAdd');
        }, icon: Icon(CupertinoIcons.back)),
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text('장소 검색'),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextField(
                      controller: searchController,
                      hintText: '이곳에서 검색 하세요',
                      color: Color(0xFFF9F9F9),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    ref.read(placeNotifierProvider.notifier).fetchPlacesByKeyword(searchController.text);
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Expanded(
              child: placeAsyncValue.when(
                  data: (placeResponse) {
                    List<Place> filteredPlaces = placeResponse!.places;

                    return ListView.builder(
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = filteredPlaces[index];
                        // Map<String, dynamic> place = places[index];
                        return GestureDetector(
                          onTap: () {
                            GoRouter.of(context).go('/placeAdd', extra: place);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.location_on_rounded),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        place.placeName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      Text(
                                        place.roadAddressName,
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                Text(place.distance)
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (err, stack) => Center(child: Text("Error: \$err")),
                  loading: () => Center(child: CircularProgressIndicator())),
            )
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:my_couple_app/core/ui/component/custom_text_field.dart';
// import 'package:my_couple_app/data/model/place_keyword_request.dart';
// import 'package:my_couple_app/data/provider/place/place_provider.dart';
//
// import '../../data/model/place.dart';
// import '../../data/model/place_response.dart';
//
// class PlaceSearchScreen extends ConsumerStatefulWidget {
//   const PlaceSearchScreen({super.key});
//
//   @override
//   _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
// }
//
// class _PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
//   TextEditingController searchController = TextEditingController();
//   PlaceKeywordRequest? request;
//
//   void _searchPlaces() {
//     // final notifier = ref.read(placesProvider.notifier);
//     // notifier.searchPlaces(searchController.text);
//     setState(() {
//       request = PlaceKeywordRequest(keyword: searchController.text);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final placeAsyncValue = request == null
//         ? AsyncValue.data(PlaceResponse(places: [])) // ✅ 기본값을 명확하게 지정
//         : ref.watch(placesByKeywordProvider(request!));
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){
//           GoRouter.of(context).go('/placeAdd');
//         }, icon: Icon(CupertinoIcons.back)),
//         centerTitle: false,
//         backgroundColor: Colors.white,
//         title: Text('장소 검색'),
//       ),
//       body: DecoratedBox(
//         decoration: BoxDecoration(color: Colors.white),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: CustomTextField(
//                       controller: searchController,
//                       hintText: '이곳에서 검색 하세요',
//                       color: Color(0xFFF9F9F9),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _searchPlaces,
//                   icon: Icon(Icons.search),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: placeAsyncValue.when(
//                   data: (placeResponse) {
//                     List<Place> filteredPlaces = placeResponse.places;
//
//                     return ListView.builder(
//                       itemCount: filteredPlaces.length,
//                       itemBuilder: (context, index) {
//                         final place = filteredPlaces[index];
//                         // Map<String, dynamic> place = places[index];
//                         return GestureDetector(
//                           onTap: () {
//                             GoRouter.of(context).go('/placeAdd', extra: place);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Icon(Icons.location_on_rounded),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         place.placeName,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16.0),
//                                       ),
//                                       Text(
//                                         place.roadAddressName,
//                                         style: TextStyle(color: Colors.grey),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 Text(place.distance)
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   error: (err, stack) => Center(child: Text("Error: \$err")),
//                   loading: () => Center(child: CircularProgressIndicator())),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
