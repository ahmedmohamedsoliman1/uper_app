import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppProvider extends ChangeNotifier {

  LatLng? newLatLng ;
  String? newUserAddress;
  String? newSearchAddress;

  void equalNewLatLng (LatLng latLng) {
    newLatLng = latLng;
    print("new latlng is : $newLatLng");
   notifyListeners();
  }

  void equalNewUserAddress (String address) {
    newUserAddress = address;
    print("new address is : $newUserAddress");
    notifyListeners();
  }

  void equalNewSearchAddress (String address) {
    newSearchAddress = address;
    print("new search address is : $newSearchAddress");
    notifyListeners();
  }

}