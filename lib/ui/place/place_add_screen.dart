import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/ui/component/draggable_bar.dart';
import 'package:my_couple_app/data/model/place.dart';
import 'package:my_couple_app/data/provider/place/maker_provider.dart';
import '../../core/constants/place_category_enum.dart';
import '../../data/model/place_request.dart';
import '../../data/provider/place/google_map_provider.dart';
import '../../data/provider/place/location_provider.dart';
import '../../data/provider/place/category_provider.dart';
import '../../data/provider/place/place_provider.dart';

class PlaceAddScreen extends ConsumerStatefulWidget {
  const PlaceAddScreen({super.key});

  @override
  ConsumerState<PlaceAddScreen> createState() => _PlaceAddScreenState();
}

class _PlaceAddScreenState extends ConsumerState<PlaceAddScreen> {
  double _initialSheetChildSize = 0.25;
  double _dragScrollSheetExtent = 0;

  double _widgetHeight = 0;
  double _fabPosition = 0;
  double _fabPositionPadding = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // render the floating button on widget
        _fabPosition = _initialSheetChildSize * context.size!.height;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ref.read(googleMapControllerProvider)?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 📍 Provider에서 상태 가져오기
    final LatLng currentPosition = ref.watch(currentLocationProvider);
    final bool isCategoryView = ref.watch(isCategoryViewProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final placeAsyncValue = selectedCategory != null
        ? ref.watch(
            placesByCategoryProvider(
              PlaceRequest(
                categoryGroupCode: PlaceCategory.getCodeByLabel(
                    selectedCategory), // 카테코리 코드로 변환
                x: currentPosition.longitude.toString(), // 선택적
                y: currentPosition.latitude.toString(), // 선택적
                radius: 5000, // 기본값 사용 가능
              ),
            ),
          )
        : const AsyncValue.data(null);
    final selectedPlace = ref.watch(selectedPlaceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text("장소 검색"),
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // 📍 Google Map 위젯
                    GoogleMap(
                      key: ValueKey('google_map_key'),
                      initialCameraPosition: CameraPosition(
                        target: currentPosition,
                        zoom: 17.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        ref.read(googleMapControllerProvider.notifier).state = controller;
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      markers: ref.watch(markersProvider),
                    ),

                    // FAB with dynamic position
                    Positioned(
                      bottom: _fabPosition + _fabPositionPadding,
                      right: _fabPositionPadding, // 위치 조절
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () async {
                              ref.read(selectedPlaceProvider.notifier).state = null;
                            },
                            backgroundColor: Colors.grey[200],
                            shape: CircleBorder(),
                            mini: true,
                            child: Icon(CupertinoIcons.back),
                            heroTag: 'backToList',
                          ),
                          SizedBox(height: 16.0),
                          FloatingActionButton(
                            onPressed: () async {
                              final newPosition = await ref.read(locationUpdateProvider.future);
                              final mapController = ref.read(googleMapControllerProvider);
                              if (mapController != null) {
                                mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
                              }
                            },
                            backgroundColor: Colors.grey[200],
                            shape: CircleBorder(),
                            mini: true,
                            child: Icon(Icons.my_location),
                            heroTag: 'myLocation',
                          ),
                        ],
                      ),
                    ),

                    // 🔍 검색창
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          context.go('/placeSearch');
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => PlaceSearchScreen()));
                        },
                        child: Container(
                          height: 44,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(4, 4))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("이곳에서 검색 하세요"),
                                Icon(Icons.search)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 🔽 하단 Draggable Sheet
                    NotificationListener<DraggableScrollableNotification>(
                      onNotification: (DraggableScrollableNotification notification) {
                        setState(() {
                          _widgetHeight = context.size!.height;
                          _dragScrollSheetExtent = notification.extent;

                          // Calculate FAB position based on parent widget height and DraggableScrollable position
                          _fabPosition = _dragScrollSheetExtent * _widgetHeight;
                        });
                        return true;
                      },
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.3,
                        minChildSize: 0.3,
                        maxChildSize: isCategoryView ? 0.3 : 1.0,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16))),
                            child: Column(
                              children: [
                                DraggableBar(),
                                Expanded(
                                  child: isCategoryView
                                      ? _buildCategoryGrid(ref)
                                      : _buildPlaceList(scrollController,
                                          placeAsyncValue, selectedPlace),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ 카테고리 UI
  Widget _buildCategoryGrid(WidgetRef ref) {
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.emoji_food_beverage, 'label': '카페'},
      {'icon': Icons.restaurant, 'label': '음식점'},
      {'icon': Icons.nature_people, 'label': '관광명소'},
      {'icon': Icons.hotel, 'label': '숙박'},
      {'icon': Icons.local_parking, 'label': '주차장'},
      {'icon': Icons.theater_comedy, 'label': '문화시설'},
      {'icon': CupertinoIcons.cart_fill, 'label': '대형마트'},
      {'icon': Icons.storefront, 'label': '편의점'},
    ];

    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var category = categories[index];
        return GestureDetector(
          onTap: () {
            ref.read(selectedCategoryProvider.notifier).state =
                category['label'];
            ref.read(isCategoryViewProvider.notifier).state = false;
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: PRIMARY_COLOR,
                radius: 26.0,
                child: Icon(category['icon'], color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(category['label']),
            ],
          ),
        );
      },
    );
  }

  // ✅ 장소 목록 UI
  Widget _buildPlaceList(ScrollController scrollController,
      AsyncValue placeAsyncValue, selectedPlace) {
    return placeAsyncValue.when(
      data: (placeResponse) {
        List<Place> filteredPlaces =
            selectedPlace != null ? [selectedPlace] : placeResponse.places;

        return ListView.builder(
          shrinkWrap: true,
          controller: scrollController,
          itemCount: filteredPlaces.length,
          itemBuilder: (context, index) {
            final place = filteredPlaces[index];
            return Column(
              children: [
                Row(
                  children: [
                    // Left side (Title and Subtitle)
                    Expanded(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                place.placeName,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Text(place.categoryGroupName,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.addressName,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text(place.distance),
                            // Text('평점 3.8'),
                            Text(place.phone),
                          ],
                        ),
                      ),
                    ),

                    // Right side (Image)
                    Container(
                      width: 90, // 원하는 너비
                      height: 90, // 원하는 높이
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(color: Colors.grey),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://picsum.photos/seed/picsum/100/100',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    )
                  ],
                ),
                Divider(thickness: 0.5, indent: 10, endIndent: 10)
              ],
            );
          },
        );
      },
      error: (err, stack) => Center(child: Text("Error: \$err")),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
