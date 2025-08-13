import 'package:get/get.dart';
import '../api_services/user_service.dart';
import '../models/user.dart';

class UserController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString authToken = ''.obs; // To store and use the token

  Future<void> registerUser({
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
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final User? user = await _userService.registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phoneNumber: phoneNumber,
        addressLine1: addressLine1,
        city: city,
        zip: zip,
        state: state,
      );
      if (user != null) {
        currentUser.value = user;
        print('User registered successfully: ${user.email}');
      } else {
        errorMessage.value = 'Registration failed.';
        print('Error: Registration failed.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during registration.';
      print('Error registering user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final User? user = await _userService.loginUser(
        email: email,
        password: password,
      );
      if (user != null && user.token != null) {
        currentUser.value = user;
        authToken.value = user.token!; // Store the token
        print('User logged in successfully. Token: ${authToken.value}');
      } else {
        errorMessage.value = 'Login failed. Invalid credentials or no token.';
        print('Error: Login failed.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during login.';
      print('Error logging in user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserProfile() async {
    if (authToken.value.isEmpty) {
      errorMessage.value = 'No authentication token available.';
      print('Error: No authentication token available for profile.');
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final User? user = await _userService.getUserProfile(authToken.value);
      if (user != null) {
        currentUser.value = user;
        print('User profile fetched: ${user.email}');
      } else {
        errorMessage.value = 'Failed to fetch user profile.';
        print('Error: Failed to fetch user profile.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred fetching user profile.';
      print('Error fetching user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    currentUser.value = null;
    authToken.value = '';
    print('User logged out.');
  }
}