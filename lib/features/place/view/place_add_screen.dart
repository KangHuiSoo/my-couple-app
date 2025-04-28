import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_couple_app/core/constants/colors.dart';
import 'package:my_couple_app/core/constants/place_category_enum.dart';
import 'package:my_couple_app/core/ui/component/draggable_bar.dart';
import 'package:my_couple_app/core/ui/component/google_map/custom_google_map.dart';
import 'package:my_couple_app/core/utils/map_util.dart';
import 'package:my_couple_app/core/utils/web_view_helper.dart';
import 'package:my_couple_app/features/auth/provider/auth_provider.dart';
import 'package:my_couple_app/features/place/model/place.dart';
import 'package:my_couple_app/features/place/model/place_response.dart';
import 'package:my_couple_app/features/place/viewmodel/place_view_model.dart';
import 'package:my_couple_app/features/place/provider/place_provider.dart';

class PlaceAddScreen extends ConsumerStatefulWidget {
  final Place? searchPlace;

  const PlaceAddScreen({this.searchPlace, super.key});

  @override
  ConsumerState<PlaceAddScreen> createState() => _PlaceAddScreenState();
}

class _PlaceAddScreenState extends ConsumerState<PlaceAddScreen> {
  double _initialSheetChildSize = 0.3;
  double _dragScrollSheetExtent = 0;

  double _widgetHeight = 0;
  double _fabPosition = 0;
  double _fabPositionPadding = 10;

  @override
  void initState() {
    super.initState();
    // 📌 UI 빌드 완료 후 실행 (지도 컨트롤러 초기화 고려)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.searchPlace != null) {
        Future.microtask(() {
          ref.read(isCategoryViewProvider.notifier).state = false;
          ref.read(selectedPlaceProvider.notifier).state = widget.searchPlace;

          // ✅ 마커 추가
          // final notifierRef = ref.read(placeNotifierProvider.notifier).ref;
          addSearchMarkers(ref, [widget.searchPlace!]);

          // ✅ 새로운 위치 설정 (검색된 장소)
          final newPosition = LatLng(
            double.parse(widget.searchPlace!.y), // 위도 (y)
            double.parse(widget.searchPlace!.x), // 경도 (x)
          );
          ref.read(currentLocationProvider.notifier).state = newPosition;

          // ✅ 지도 이동을 위한 대기 시간 추가
          Future.delayed(Duration(milliseconds: 500), () {
            final mapController = ref.read(googleMapControllerProvider);
            if (mapController != null) {
              print("✅ 지도 이동: $newPosition");
              mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
            } else {
              print("❌ GoogleMapController가 아직 초기화되지 않음");
            }
          });
        });
      }
      setState(() {
        // render the floating button on widget
        _fabPosition = _initialSheetChildSize * context.size!.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 📍 Provider에서 상태 가져오기
    final LatLng currentPosition = ref.watch(currentLocationProvider);
    final bool isCategoryView = ref.watch(isCategoryViewProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final placeAsyncValue = ref.watch(placeNotifierProvider);
    final selectedPlace = ref.watch(selectedPlaceProvider);
    final markers = ref.watch(markersProvider);
    final valueKey = ValueKey('google_map_key');
    final initialZoom = 17.0;

    final authState = ref.watch(authViewModelProvider);
    final currentUser = authState.user;
    print("유저정보 --->>> ${currentUser}");

    return Scaffold(
      backgroundColor: Colors.white,
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
                    CustomGoogleMap(
                      valueKey: valueKey,
                      initialPosition: CameraPosition(
                        target: currentPosition,
                        zoom: initialZoom,
                      ),
                      onMapCreated: (controller) {
                        ref.read(googleMapControllerProvider.notifier).state =
                            controller;
                      },
                      markers: markers,
                    ),

                    // 장소추가 FAB 버튼
                    _buildFloatingActionButtons(),
                    // 검색바
                    _buildSearchBar(selectedCategory),
                    // 바텀 시트
                    _buildBottomSheet(
                        isCategoryView,
                        placeAsyncValue,
                        selectedPlace,
                        currentPosition,
                        selectedDate ?? DateTime.now().toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ 하단 바텀 시트 UI
  Widget _buildBottomSheet(
      bool isCategoryView,
      AsyncValue<PlaceResponse?> placeAsyncValue,
      Place? selectedPlace,
      LatLng currentPosition,
      String selectedDate) {
    return NotificationListener<DraggableScrollableNotification>(
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
        builder: (BuildContext context, ScrollController scrollController) {
          return DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Column(
              children: [
                DraggableBar(),
                Expanded(
                  child: isCategoryView
                      ? _buildCategoryGrid(ref, currentPosition)
                      : _buildPlaceList(scrollController, placeAsyncValue,
                          selectedPlace, selectedDate),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ 검색바 UI
  Widget _buildSearchBar(String? selectedCategory) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                context.go('/placeSearch');
              },
              child: Container(
                height: 44,
                // width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(4, 4))
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedCategory ?? '이곳에서 검색하세요'),
                      selectedCategory != null
                          ? IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                ref
                                    .read(isCategoryViewProvider.notifier)
                                    .state = true;
                                ref
                                    .read(selectedCategoryProvider.notifier)
                                    .state = null;
                                ref.read(markersProvider.notifier).state = {};
                              },
                              icon: Icon(CupertinoIcons.xmark),
                            )
                          : Icon(Icons.search),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ FAB
  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: _fabPosition + _fabPositionPadding,
      right: _fabPositionPadding, // 위치 조절
      child: Row(
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              ref.read(isCategoryViewProvider.notifier).state = true;
            },
            backgroundColor: Colors.grey[200],
            heroTag: 'backToList',
            label: Text("카테고리"),
            icon: Icon(Icons.category),
          ),
          SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: () async {
              ref.read(selectedPlaceProvider.notifier).state = null;
            },
            backgroundColor: Colors.grey[200],
            shape: CircleBorder(),
            mini: true,
            heroTag: 'backToList',
            child: Icon(CupertinoIcons.back),
          ),
          SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: () async {
              final newPosition = await ref.read(locationUpdateProvider.future);
              ref.read(currentLocationProvider.notifier).state = newPosition;

              Future.delayed(Duration(milliseconds: 500), () {
                final mapController = ref.read(googleMapControllerProvider);
                if (mapController != null) {
                  print("✅ 현재 위치 이동: $newPosition");
                  mapController
                      .animateCamera(CameraUpdate.newLatLng(newPosition));
                } else {
                  print("❌ GoogleMapController가 아직 초기화되지 않음");
                }
              });
            },
            backgroundColor: Colors.grey[200],
            shape: CircleBorder(),
            mini: true,
            heroTag: 'myLocation',
            child: Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  // ✅ 카테고리 UI
  Widget _buildCategoryGrid(WidgetRef ref, LatLng currentPosition) {
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
            print("위도경도 확인 ------");
            print(currentPosition.latitude.toString());
            print(currentPosition.longitude.toString());
            ref.read(placeNotifierProvider.notifier).fetchPlacesByCategory(
                ref, PlaceCategory.getCodeByLabel(category['label']),
                x: currentPosition.longitude.toString(),
                y: currentPosition.latitude.toString(),
                radius: 5000);
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

  // 해당 장소 클릭시 다이얼로그 출력
  void _showPlaceDialog(
      BuildContext context, Place place, String? selectedDate) {
    if (selectedDate == null) return; // 날짜가 없으면 다이얼로그를 보여주지 않음

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.placeName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("📍 ${place.roadAddressName}"),
                Text("📞 ${place.phone}"),
                Text("📏 거리: ${place.distance}m"),
                TextButton(
                    onPressed: () {
                      WebViewHelper.openWebView(context, place.placeUrl);
                    },
                    child: Text('자세히 >')),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("닫기", style: TextStyle(color: Colors.blue)),
                      ),
                      TextButton(
                        onPressed: () {
                          final updatedPlace =
                              place.copyWith(selectedDate: selectedDate);
                          ref
                              .read(placeNotifierProvider.notifier)
                              .addPlace(updatedPlace);
                          Navigator.pop(context);
                        },
                        child: Text("추가", style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ✅ 장소 목록 UI
  Widget _buildPlaceList(ScrollController scrollController,
      AsyncValue placeAsyncValue, selectedPlace, String selectedDate) {
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
                        onTap: () {
                          // GoRouter.of(context).go('/placeDetail?url=${place.placeUrl}');
                          // WebViewHelper.openWebView(context, place.placeUrl);
                          _showPlaceDialog(context, place, selectedDate);
                        },
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
                            Text('${place.distance}m'),
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
      error: (err, stack) => Center(child: Text("Error: $err")),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
