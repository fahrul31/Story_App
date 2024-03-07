import 'dart:io';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/page_map_manager.dart';
import 'package:story_app/provider/story_provider.dart';

class AddStoryScreen extends StatefulWidget {
  final Function onSend;
  final Function onPickMap;
  const AddStoryScreen({
    super.key,
    required this.onSend,
    required this.onPickMap,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _textController = TextEditingController();
  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add Story"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    context.watch<AddStoryProvider>().photoPath == null
                        ? const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 300,
                            ),
                          )
                        : _showImage(),
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(25, 45),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: const Color(0xffEF6A37).withOpacity(0.8),
                              width: 2,
                            ),
                          ),
                          onPressed: () => _onGalleryView(),
                          child: const Text(
                            "Gallery",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(25, 45),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: const Color(0xffEF6A37).withOpacity(0.8),
                              width: 2,
                            ),
                          ),
                          onPressed: () => _onCameraView(),
                          child: const Text(
                            "Camera",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: _textController,
                    minLines: 3,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      label: Text(
                        "Description",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Color(0xffEF6A37),
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(20, 40),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: const Color(0xffEF6A37).withOpacity(0.8),
                              width: 2,
                            ),
                          ),
                          onPressed: () async {
                            await pickMap(context);
                          },
                          child: const Text(
                            "Pick Location",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 20),
                        if (placemark != null) ...[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  placemark!.street!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  '${placemark!.subLocality!}, ${placemark!.locality!}, ${placemark!.postalCode!}, ${placemark!.country!}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                context.watch<AddStoryProvider>().isLoadingForm
                    ? const Center(child: CircularProgressIndicator())
                    : Consumer<AddStoryProvider>(
                        builder: (context, state, _) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width,
                                  50,
                                ),
                                backgroundColor: const Color(0xffEF6A37),
                              ),
                              onPressed: () async {
                                await onSend(context);
                              },
                              child: const Text(
                                "Send",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickMap(BuildContext context) async {
    widget.onPickMap();
    final pageMapManager = context.read<PageMapManager>();
    final addstoryRead = context.read<AddStoryProvider>();
    final dataLatLng = await pageMapManager.waitForResult();

    addstoryRead.pickMap = dataLatLng;

    final info = await geo.placemarkFromCoordinates(
        addstoryRead.pickMap!.latitude, addstoryRead.pickMap!.longitude);

    final place = info[0];
    setState(() {
      placemark = place;
    });
  }

  Future<void> onSend(BuildContext context) async {
    final addStoryRead = context.read<AddStoryProvider>();
    final storyRead = context.read<StoryProvider>();

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final description = _textController.text;
    if (context.read<AddStoryProvider>().photo != null &&
        description.isNotEmpty) {
      final result =
          await context.read<AddStoryProvider>().addStory(description);

      if (!result) {
        final message = addStoryRead.addStoryResult.message;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } else {
        storyRead.allStories();
        widget.onSend();
        addStoryRead.isSuccess = false;
        addStoryRead.photoPath = null;
        addStoryRead.photo = null;
      }
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Pilih foto atau isi deskripsi terlebih dahulu"),
        ),
      );
    }
  }

  _onGalleryView() async {
    final provider = context.read<AddStoryProvider>();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      provider.photo = pickedFile;
      provider.photoPath = pickedFile.path;
    }
  }

  _onCameraView() async {
    final provider = context.read<AddStoryProvider>();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      provider.photo = pickedFile;
      provider.photoPath = pickedFile.path;
    }
  }

  Widget _showImage() {
    final photoPath = context.watch<AddStoryProvider>().photoPath;

    return kIsWeb
        ? Image.network(
            photoPath.toString(),
            fit: BoxFit.cover,
            height: 300,
            width: MediaQuery.of(context).size.width,
          )
        : Image.file(
            File(photoPath.toString()),
            fit: BoxFit.cover,
            height: 300,
            width: MediaQuery.of(context).size.width,
          );
  }
}
