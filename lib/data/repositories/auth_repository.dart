import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:submission_pertama/core/constants/api_constants.dart';
import 'package:submission_pertama/data/models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      debugPrint('AuthRepository: Logging in...');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserModel.fromJson(data['loginResult']);
      } else {
        debugPrint('AuthRepository: Error Response: ${response.body}');
        throw data['message'] ?? 'Login failed';
      }
    } on SocketException catch (e) {
      debugPrint('AuthRepository: Network Error: $e');
      throw 'No Internet Connection. Please check your network.';
    } catch (e) {
      debugPrint('AuthRepository: Unexpected Error: $e');
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      debugPrint('AuthRepository: Registering...');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode != 201) {
        debugPrint('AuthRepository: Error Response: ${response.body}');
        throw data['message'] ?? 'Registration failed';
      }
    } on SocketException catch (e) {
      debugPrint('AuthRepository: Network Error: $e');
      throw 'No Internet Connection. Please check your network.';
    } catch (e) {
      debugPrint('AuthRepository: Unexpected Error: $e');
      rethrow;
    }
  }
}
