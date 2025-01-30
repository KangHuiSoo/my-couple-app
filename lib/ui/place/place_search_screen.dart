import 'package:flutter/material.dart';
import 'package:my_couple_app/core/ui/component/custom_text_field.dart';

class PlaceSearchScreen extends StatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  State<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> places = [
    {
      "name": "현스시",
      "address": "부산광역시 광중길 2길",
      "distance": "230m"
    },
    {
      "name": "모도로스시",
      "address": "부산광역시 광중길 4길",
      "distance": "530m"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장소 검색'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomTextField(controller: searchController,
                  hintText: '이곳에서 검색 하세요',
                  color: Color(0xFFF9F9F9),),
              )),
              IconButton(onPressed: () {}, icon: Icon(Icons.search))
            ],
          ),

          Expanded(
            child: ListView.builder(itemCount:places.length, itemBuilder: (context, index) {
              Map<String,dynamic> place = places[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.location_on_rounded),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place["name"], style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                          ),),
                          Text(place["address"], style: TextStyle(
                            color: Colors.grey
                          ),)
                        ],
                      ),
                    ),
                    Text(place['distance'])
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
