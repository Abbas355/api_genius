import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import '../models/user.dart';

class UserService {
  final String _baseUrl = ApiConstants.BASE_URL;

  Future<User?> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phoneNumber,
    required String addressLine1,
    required String city,
    required String zip,
    required String state,
  }) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.AUTH_REGISTER}');
      var request = http.MultipartRequest('POST', uri)
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['password_confirmation'] = passwordConfirmation
        ..fields['phone_number'] = phoneNumber
        ..fields['address_line_1'] = addressLine1
        ..fields['city'] = city
        ..fields['zip'] = zip
        ..fields['state'] = state;

      request.headers['Accept'] = 'application/json';

      final http.StreamedResponse streamedResponse = await request.send();
      final http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        print('Failed to register user: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during user registration: $e');
      return null;
    }
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.AUTH_LOGIN}');
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded', // Default for http.post with Map body
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse); // Assuming User model handles 'token'
      } else {
        print('Failed to login user: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during user login: $e');
      return null;
    }
  }

  Future<User?> getUserProfile(String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.USER_PROFILE}');
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        print('Failed to get user profile: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
}