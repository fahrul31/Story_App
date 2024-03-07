import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/provider/story_provider.dart';

class StoryDetailPage extends StatefulWidget {
  final Function(LatLng) onMap;
  final String storyId;
  const StoryDetailPage({
    Key? key,
    required this.storyId,
    required this.onMap,
  }) : super(key: key);

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage>
    with SingleTickerProviderStateMixin {
  late Tween<double> animation;
  @override
  void initState() {
    super.initState();
    animation = Tween<double>(begin: 0.0, end: 15);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailStoryProvider>(
      create: (_) => DetailStoryProvider(
        authRepository: AuthRepository(),
        apiService: ApiService(),
        id: widget.storyId,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Detail Story"),
          ),
          body: _build(),
        ),
      ),
    );
  }

  Widget _build() {
    return Consumer<DetailStoryProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: animation,
                    duration: const Duration(seconds: 3),
                    builder: (context, double value, child) {
                      return Transform.rotate(
                        angle: value,
                        child: Image.asset(
                          "assets/loading.png",
                          height: 50,
                          width: 50,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          );
        } else if (state.state == ResultState.hasData) {
          var story = state.detailStoryResult.story;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.account_circle),
                      ),
                      const SizedBox(width: 8),
                      Text(story.name,
                          style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.more_horiz)
                    ],
                  ),
                ),
                FadeInImage.assetNetwork(
                  placeholder: "assets/block.gif",
                  placeholderFit: BoxFit.cover,
                  image: story.photoUrl,
                  fit: BoxFit.cover,
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  fadeInDuration: const Duration(seconds: 1),
                  fadeOutDuration: const Duration(seconds: 1),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.thumb_up_off_alt_outlined, size: 25),
                          const SizedBox(width: 8),
                          Text(
                            "${Random().nextInt(100)} Liked",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);

                              if (story.lat != null && story.lon != null) {
                                final storyLocation =
                                    LatLng(story.lat!, story.lon!);
                                widget.onMap(storyLocation);
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  const SnackBar(
                                    duration: Duration(milliseconds: 750),
                                    content:
                                        Text("Lokasi Story Tidak Tersedia"),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Location",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          text: 'Deskripsi \n',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: <TextSpan>[
                            TextSpan(
                              text: '${story.description} ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state.state == ResultState.noData) {
          return Center(
            child: Material(
              child: Text(state.message),
            ),
          );
        } else if (state.state == ResultState.error) {
          return const Center(
            child: Material(
              child: Text("Internet Not Found"),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }
}
