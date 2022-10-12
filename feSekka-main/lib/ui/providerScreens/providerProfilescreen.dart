// ignore_for_file: unused_field

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/provider/profileData.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/editProviderScreen.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderProfileScreen extends StatefulWidget {
  @override
  _ProviderProfileScreenState createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  bool isLoading = true;
  bool? locationEnabled = false;
  ProfileData? data;
  GoogleMapController? _controller;

  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    locationEnabled = prefs.getBool("locationEnabled") ?? false;
    data = await ServiceProviderService().getProfileData();
    isLoading = false;
    setState(() {});
  }

  updateLocationEnabled(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("locationEnabled", newValue);
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Loader()
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage("${data!.image}"),
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('name')}:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${data!.name}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('phoneNumber')}:",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${data!.mobile}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('whatsAppClicks')}:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${data!.whatsappClicks}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('phoneClicks')}:",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${data!.mobileClicks}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Whatsapp:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${data!.whatsapp == null ? " - " : data!.whatsapp}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.translate('chatSupport')}:",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${data!.orders == null ? " - " : data!.orders}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  height: 100,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: data!.lat == null || data!.lat == ""
                          ? LatLng(0, 0)
                          : LatLng(
                              double.parse(data!.lat!), double.parse(data!.long!)),
                      zoom: 19.151926040649414,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      setState(() {});
                    },
                    markers: {
                      Marker(
                        markerId: MarkerId("currentState"),
                        position: data!.lat == "null" || data!.lat == ""
                            ? LatLng(0, 0)
                            : LatLng(double.parse(data!.lat!),
                                double.parse(data!.long!)),
                        infoWindow: InfoWindow(
                          title: "${data!.name}",
                        ),
                        icon: BitmapDescriptor.defaultMarker,
                      )
                    },
                    liteModeEnabled: true,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CheckboxListTile(
                  title: Text(
                      "${AppLocalizations.of(context)!.translate('updateLocationEnabled')}"),
                  value: locationEnabled,
                  onChanged: (newValue) {
                    updateLocationEnabled(newValue!);
                    setState(() {
                      locationEnabled = newValue;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    pushPage(
                        context,
                        EditProfileScreen(
                          data: data,
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.green),
                    child: Text(
                        "${AppLocalizations.of(context)!.translate('edit')}",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }
}
