import 'package:freezed_annotation/freezed_annotation.dart';

import 'detail_story.dart';
part 'story_result.g.dart';
part 'story_result.freezed.dart';

@freezed
class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    required bool error,
    required String message,
    required List<Story> listStory,
  }) = _StoriesResponse;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);
}
