import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zohoclone/config/app_provider.dart';
import 'package:zohoclone/screens/search_places_screen.dart';
import 'package:zohoclone/utils/app_constants.dart';

import 'package:location/location.dart' as loc;

import 'package:http/http.dart' as https;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static String route = AppConstants.mainRoute ;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final Completer<GoogleMapController> mainGoogleMapController =
  Completer<GoogleMapController>();

  GoogleMapController? newController ;

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? userCurrentPosition ;
  var geolocation = Geolocator();

  LocationPermission? locationPermission ;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  loc.Location location = loc.Location() ;
  LatLng? pickLocation ;
  String address = "Please wait ....";

  List<LatLng> pLineCoordinatedList = [] ;
  Set<Polyline> polyLinesSet = {} ;
  Set<Marker> markersSet = {} ;
  Set<Circle> circlesSet = {} ;


  String userName = "" ;
  String userEmail = "" ;


  bool openNavigationDrawer = true ;
  bool activeNearbyDriverKey = false ;
  BitmapDescriptor? activeNearbyIcons ;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
                initialCameraPosition: kGooglePlex ,
                mapType: MapType.normal,
              markers: markersSet,
              circles: circlesSet,
              polylines: polyLinesSet,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller){
                  mainGoogleMapController.complete(controller);
                  newController = controller ;
                  setState(() {
                    locateUserPosition() ;
                  });
              },
              onCameraMove: (CameraPosition? position){
                  if(position != null) {
                    if(pickLocation != position.target){
                      pickLocation = position.target ;
                      setState(() {
                        Provider.of<AppProvider>(context , listen: false).equalNewLatLng(pickLocation!);
                      });
                    }
                  }

              },
              onCameraIdle: () {
                getAddressFromCoordinates();
              },
            ) ,
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Icon(Icons.location_on , size: 45, color: Colors.red,),
              ),
            ),
            // Positioned(
            //     top: 50,
            //     left: 20,
            //     right: 20,
            //     child: Container(
            //       padding: const EdgeInsets.all(10),
            //       height: 80,
            //       width: 200,
            //       decoration: BoxDecoration(
            //         color: Colors.white ,
            //         borderRadius: BorderRadius.circular(20)
            //       ),
            //       child: Center(
            //         child: Text(address,
            //         overflow: TextOverflow.visible , softWrap :true ,
            //         style: const TextStyle(
            //           color: Colors.red
            //         ), textAlign: TextAlign.center,),
            //       ),
            //     )),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white ,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on , color: Colors.blue, size: 25,) ,
                              Text("From" , style: TextStyle(
                                fontSize: 16
                              ),)
                            ],
                          ) ,
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Expanded(
                                child: Text(Provider.of<AppProvider>(context , listen: false).newUserAddress != null ?
                                Provider.of<AppProvider>(context , listen: false).newUserAddress! :
                                address ,
                                overflow: TextOverflow.ellipsis ,
                                maxLines: 2,),
                              ),
                            ],
                          )
                        ],
                      ) ,
                      const Divider(
                        color: Colors.blue,
                        indent: 30 ,
                        endIndent: 30,
                        thickness: 0.5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, SearchPlacesScreen.route);
                        },
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on , color: Colors.blue, size: 25,) ,
                                Text("To" , style: TextStyle(
                                    fontSize: 16
                                ),)
                              ],
                            ) ,
                            const SizedBox(height: 5,),
                            Consumer<AppProvider>(
                                builder: (context , provider , _){
                                  if (provider.newSearchAddress != null){
                                    return Row(
                                      children: [
                                        Text(Provider.of<AppProvider>(context).newSearchAddress!),
                                      ],
                                    );
                                  }else {
                                    return const Row(
                                      children: [
                                        Text("to where ? "),
                                      ],
                                    );
                                  }
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void locateUserPosition() async{
    LocationPermission request = await Geolocator.requestPermission();
    if (request == LocationPermission.denied){
     print("user denied");
    }
    else {
     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async{
       userCurrentPosition = value ;
         LatLng userPositionLatLang = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
         CameraPosition cameraPosition = CameraPosition(target: userPositionLatLang , zoom: 15);
         newController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
         print("donnnne");
       setState(() {
       });


     }
     );



   }

  }

  // getAddressFromLatLng(context, double lat, double lng) async {
  //   String host = 'https://maps.google.com/maps/api/geocode/json';
  //   final url = '$host?key=${AppConstants.mapKey}&language=ar&latlng=$lat,$lng';
  //   var response = await https.get(Uri.parse(url));
  //   if(response.statusCode == 200) {
  //     Map data = jsonDecode(response.body);
  //     String formattedAddress = data["results"][0]["formatted_address"];
  //     print("response ==== $formattedAddress");
  //     return formattedAddress;
  //   } else {
  //     return null;
  //   }
  //   }

    getAddressFromCoordinates () async{
      try{
        await placemarkFromCoordinates(
            pickLocation!.latitude,
            pickLocation!.longitude).then((placemarks) {
          var place = placemarks[0];
          address = place.street! ;
          Provider.of<AppProvider>(context , listen: false).equalNewUserAddress(address);
          print("address : $address");
          print("lat : ${pickLocation!.latitude}");
          print("lng : ${pickLocation!.longitude}");
          return null;
        });
        setState(() {

        });
      }catch (e){
        print("errrroooor is : $e") ;
      }
    }
}
