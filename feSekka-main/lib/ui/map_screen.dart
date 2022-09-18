import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

import '../widgets/loader.dart';





class MapScreen extends StatefulWidget {




  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  bool gettingLocation =true;
  String previousMarkerId = "";

  bool locUpdated = false;
  String countryCode="";
  int _markerIdCounter = 1;
  String googleApikey = "AIzaSyAiXI2OUVPLWu_TiDda-qrqQ-QJ0Fcoyj4";
  String location = "Search Location";
  late LatLng position;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  String address="";


  @override
  void initState() {
    _getCurrentLocation();

    super.initState();
  }
  add(double lat,double lang) {
    print("_add$lang$lat");
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    previousMarkerId=markerIdVal;
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
          lat,lang
      ),
      infoWindow: InfoWindow(title: Localizations.localeOf(context).languageCode == "en" ?"your Current Location":"مكانك الحالى", snippet: Localizations.localeOf(context).languageCode == "en" ?"this is your location will be set in app":"هذا هو المكان الذى تريد تعديله في التطبيق"),

    );
    position = LatLng(
        lat,lang
    );
    getAddressOfLocation(lat,lang);

    setState(() {
      markers[markerId] = marker;
    });
  }
  _createMarker() {
    setState(() {
      print("create Marker$position");
      add(position.latitude, position.longitude);
    });
    setState(() {

      gettingLocation=false;
    });


  }

  getAddressOfLocation(double lat,double long) async {
    List<Placemark> i =
    await placemarkFromCoordinates(lat, long);
    Placemark placeMark = i.first;
    countryCode=placeMark.isoCountryCode!;

    address="${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";

    setState(() {
    });
    print(address);


  }


  remove(MarkerId markerId,LatLng pos) {
    setState(() {
      if (markers.containsKey(markerId)) {
        markers.remove(markerId);
        print('removed');
        add(pos.latitude, pos.longitude);


      }
    });
  }
  //map style variable
  void _addMarker(LatLng pos) async {
    if ((pos.latitude != position.latitude&&position.longitude!=pos.longitude )) {
      remove(MarkerId(previousMarkerId),pos);

      setState(() {});
    }

  }
  void _getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = LatLng(
          res.latitude,res.longitude
      );

    });
    _createMarker();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.2,

        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), topLeft: Radius.circular(10),),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              address,
              style: TextStyle(color: Colors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                print(position.latitude);
                print(position.longitude);
                Navigator.pop(context,position);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color:  Color(0xFF66a5b4)),
                child: Text(Localizations.localeOf(context).languageCode == "en" ?"this is the location":"هذا هو المكان",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),

          ],
        ),
      ),
      body: gettingLocation?Loader():Stack(
        children: [
          GoogleMap(
            onTap: _addMarker,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            markers: Set<Marker>.of(markers.values),
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(  //search input bar
              top:10,
              child: InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: googleApikey,
                        mode: Mode.overlay,
                        types: [],
                        strictbounds: false,
                        components: [Component(Component.country, countryCode)],
                        //google_map_webservice package
                        onError: (err){
                          print(err);
                        }
                    );

                    if(place != null){
                      setState(() {
                        location = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(apiKey:googleApikey,
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );
                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);
                      _addMarker(newlatlang);



                      //move map camera to selected place with animation
                      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                      setState(() {

                      });
                    }
                  },
                  child:Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title:Text(location, style: TextStyle(fontSize: 18),),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )
                      ),
                    ),
                  )
              )
          )

        ],
      ),

    );
  }
}