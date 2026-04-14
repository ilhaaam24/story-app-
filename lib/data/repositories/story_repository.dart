import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/constants/api_constants.dart';
import '../models/story_model.dart';

class StoryRepository {
  // Get stories dengan pagination
  Future<StoryListResponse> getStories({
    required String token,
    int page = 1,
    int size = 10,
    int location = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.stories}'
          '?page=$page&size=$size&location=$location',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return StoryListResponse.fromJson(data);
      } else {
        throw data['message'] ?? 'Failed to load stories';
      }
    } on SocketException {
      throw 'No Internet Connection. Please check your network.';
    } catch (e) {
      debugPrint('StoryRepository: getStories Error: $e');
      rethrow;
    }
  }

  // Get story detail
  Future<StoryModel> getStoryDetail(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.stories}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return StoryModel.fromJson(data['story']);
      } else {
        throw data['message'] ?? 'Failed to load story detail';
      }
    } catch (e) {
      debugPrint('StoryRepository: getStoryDetail Error: $e');
      rethrow;
    }
  }

  // Add story dengan lokasi
  Future<void> addStory({
    required String token,
    required String description,
    required File imageFile,
    double? lat,
    double? lon,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.addStory}'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = description;

      if (lat != null && lon != null) {
        request.fields['lat'] = lat.toString();
        request.fields['lon'] = lon.toString();
      }

      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (response.statusCode != 201) {
        throw data['message'] ?? 'Failed to add story';
      }
    } catch (e) {
      debugPrint('StoryRepository: addStory Error: $e');
      rethrow;
    }
  }
}
