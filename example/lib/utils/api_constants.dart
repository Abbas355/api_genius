class ApiConstants {
  static const String BASE_URL = 'http://localhost:8000';
  static const String API_PREFIX = '/api';

  // Auth Endpoints
  static const String AUTH_REGISTER = '$API_PREFIX/auth/register';
  static const String AUTH_LOGIN = '$API_PREFIX/auth/login';

  // User Endpoints
  static const String USER_PROFILE = '$API_PREFIX/user/profile';

  // Product Endpoints
  static const String PRODUCTS = '$API_PREFIX/products';
  static const String PRODUCTS_BY_ID = '$API_PREFIX/products/'; // Append ID

  // Order Endpoints
  static const String ORDERS = '$API_PREFIX/orders';
}