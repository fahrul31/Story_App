import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:story_app/widget/placemark_custom.dart';

class MapScreen extends StatefulWidget {
  final Function() onBack;
  final LatLng storyLocation;
  const MapScreen({
    super.key,
    required this.onBack,
    required this.storyLocation,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Location Story"),
        leading: IconButton(
          onPressed: () => widget.onBack(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) async {
                await onMap(controller);
              },
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: widget.storyLocation,
              ),
              markers: markers,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                children: [
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
                bottom: 20,
                right: 20,
                left: 20,
                child: PlacemarkCustom(
                  placemark: placemark!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> onMap(GoogleMapController controller) async {
    var (street, address) = await infoMap(widget.storyLocation);
    defineMarker(widget.storyLocation, street, address);
    final marker = Marker(
      markerId: const MarkerId("Source"),
      position: widget.storyLocation,
    );
    setState(() {
      mapController = controller;
      markers.add(marker);
    });
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
}
