import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/model/detail_story_result.dart';
import 'package:story_app/model/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/model/register_result.dart';
import 'package:story_app/model/story_result.dart';
import 'package:story_app/model/user.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<LoginResponse> userLogin(User user) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      body: {
        "email": user.email,
        "password": user.password,
      },
    );
    return LoginResponse.fromJson(json.decode(response.body));
  }

  Future<DefaultResult> userRegister(User user) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      body: {
        "name": user.name,
        "email": user.email,
        "password": user.password,
      },
    );

    return DefaultResult.fromJson(json.decode(response.body));
  }

  Future<StoriesResponse> listStory(
    String token,
    int page,
    int size, [
    int location = 0,
  ]) async {
    final response = await http.get(
      Uri.parse(
        "$_baseUrl/stories?page=$page&size=$size&location=$location",
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token '
      },
    );
    return StoriesResponse.fromJson(json.decode(response.body));
  }

  Future<DetailStoryResult> detailStory(String token, String id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/stories/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token '
      },
    );

    return DetailStoryResult.fromJson(json.decode(response.body));
  }

  Future<DefaultResult> addStory(
    String token,
    XFile photo,
    String description, [
    double lat = 0,
    double lon = 0,
  ]) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("$_baseUrl/stories"),
    );

    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['description'] = description;
    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();

    final fileStream =
        http.ByteStream(Stream.castFrom(File(photo.path).openRead()));
    final length = await File(photo.path).length();

    request.files.add(
      http.MultipartFile(
        'photo',
        fileStream,
        length,
        filename: photo.name,
      ),
    );

    final response = await http.Response.fromStream(await request.send());

    return DefaultResult.fromJson(json.decode(response.body));
  }
}
