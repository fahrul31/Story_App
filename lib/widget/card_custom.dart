import 'package:flutter/material.dart';
import 'package:story_app/model/detail_story.dart';

class CardCostum extends StatelessWidget {
  const CardCostum({
    super.key,
    required this.story,
  });

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: FadeInImage.assetNetwork(
              placeholder: "assets/block.gif",
              placeholderFit: BoxFit.none,
              image: story.photoUrl,
              fit: BoxFit.cover,
              height: 200,
              width: MediaQuery.of(context).size.width,
              fadeInDuration: const Duration(seconds: 1),
              fadeOutDuration: const Duration(seconds: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              story.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }
}
