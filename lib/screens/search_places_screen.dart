import 'dart:convert';

import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:zohoclone/config/app_provider.dart';
import 'package:zohoclone/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_google_places/flutter_google_places.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  static String route = AppConstants.searchPlacesRoute;

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

  TextEditingController searchController = TextEditingController();

  final places = GoogleMapsPlaces(apiKey: AppConstants.mapKey);

  List<PlacesSearchResult> placesList = [] ;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text(
            "Search places", style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)
                    )
                ),
                child: InkWell(
                  // onTap: () async{
                  //   Prediction? p = await PlacesAutocomplete.show(
                  //       context: context,
                  //       offset: 0,
                  //       radius: 100000,
                  //       types: ["(cities)"],
                  //       strictbounds: false,
                  //       mode: Mode.overlay,
                  //       language: "en",
                  //       region: "us",
                  //       components: [ //add this
                  //         Component(
                  //             Component.country, "fr"),
                  //       ],
                  //       apiKey: AppConstants.mapKey);
                  //   if (p == null){
                  //     print("p is :$p");
                  //   }
                  // },
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white,),
                      const SizedBox(width: 10,),
                      Expanded(
                          child: TextFormField(
                            onChanged: (input) async {
                              searchController.text = input;
                              setState(() {
                                 searchAllPlaces(searchController.text);
                              });
                            },
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Search for a place ...",
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
              searchController.text.isEmpty ?
                  const SizedBox() :
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context , index) => const Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                    shrinkWrap: true,
                    itemCount: placesList.length,
                    itemBuilder: (context , index) => InkWell(
                      onTap: () {
                        searchController.text = placesList[index].name ;
                        Provider.of<AppProvider>(context , listen: false).equalNewSearchAddress(placesList[index].name);
                        Navigator.pop(context);
                        setState(() {

                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded , color: Colors.grey,),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Text(
                                  placesList[index].name
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  textSearch(String queryValue) async {
    var headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': AppConstants.mapKey,
      'X-Goog-FieldMask':
      'places.displayName,places.name,places.id,places.formattedAddress'
    };
    var request = http.Request('POST',
        Uri.parse('https://places.googleapis.com/v1/places:searchText'));
    request.body = json.encode({"textQuery": queryValue});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print("result is : ${result}");
    } else {
      print("response.reasonPhrase is : ${response.reasonPhrase}");
    }
  }

  /// nearby places
  Future<List<PlacesSearchResult>> searchPlaces(String query,
      LatLng location) async {
    final result = await places.searchNearbyWithRadius(
      Location(lat: location.latitude, lng: location.longitude),
      5000,
      type: "restaurant",
      keyword: query,
    );
    if (result.status == "OK") {
      return result.results;
    } else {
      throw Exception(result.errorMessage);
    }
  }

  /// all places
  Future<List<PlacesSearchResult>> searchAllPlaces(String query) async {
    if (query.isNotEmpty){
      final result = await places.searchByText(query);
      if (result.status == "OK") {
        print("results is : ${result.results}");
        placesList = result.results ;
        setState(() {

        });
        return result.results;
      } else {
        throw Exception(result.errorMessage);
      }
    }else {
      return [] ;
    }
  }

}


