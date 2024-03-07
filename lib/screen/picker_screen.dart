import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/page_map_manager.dart';
import 'package:story_app/widget/placemark_custom.dart';

class PickerScreen extends StatefulWidget {
  final Function() onBack;
  final Function() onPick;
  const PickerScreen({
    super.key,
    required this.onBack,
    required this.onPick,
  });

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late LatLng dataLocation = dicodingOffice;
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pick Your Location Story"),
        leading: IconButton(
          onPressed: () => widget.onBack(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: dicodingOffice,
              ),
              onTap: (LatLng latLng) {
                onTapGoogleMap(latLng);
              },
              onMapCreated: (controller) async {
                var (street, address) = await infoMap(dicodingOffice);
                defineMarker(dicodingOffice, street, address);
                final marker = Marker(
                  markerId: const MarkerId("Source"),
                  position: dicodingOffice,
                );
                setState(() {
                  mapController = controller;
                  markers.add(marker);
                });
              },
              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 25,
              right: 25,
              child: Column(
                children: [
                  FloatingActionButton(
                    child: const Icon(Icons.my_location),
                    onPressed: () {
                      onMyLocationButtonPress();
                    },
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.small(
                    heroTag: "zoom-in",
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton.small(
                    heroTag: "zoom-out",
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            if (placemark != null) ...[
              Positioned(
                bottom: 100,
                right: 20,
                left: 20,
                child: PlacemarkCustom(
                  placemark: placemark!,
                ),
              ),
            ],
            Positioned.fill(
              bottom: 30,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        MediaQuery.of(context).size.width,
                        50,
                      ),
                      backgroundColor: const Color(0xffEF6A37),
                    ),
                    onPressed: () {
                      widget.onPick();
                      context.read<PageMapManager>().returnData(dataLocation);
                    },
                    child: const Text(
                      "Pick Location",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapGoogleMap(LatLng latLng) async {
    dataLocation = latLng;
    var (street, address) = await infoMap(latLng);
    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  Future<(String, String)> infoMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    return (street, address);
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);
    dataLocation = latLng;
    var (street, address) = await infoMap(latLng);
    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
