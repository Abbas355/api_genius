import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import '../models/order.dart';

class OrderService {
  final String _baseUrl = ApiConstants.BASE_URL;

  Future<Order?> createOrder({
    required int productId,
    required int quantity,
    required String shippingAddress,
    required String token,
  }) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.ORDERS}');
      var request = http.MultipartRequest('POST', uri)
        ..fields['product_id'] = productId.toString()
        ..fields['quantity'] = quantity.toString()
        ..fields['shipping_address'] = shippingAddress;

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      final http.StreamedResponse streamedResponse = await request.send();
      final http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Order.fromJson(jsonResponse);
      } else {
        print('Failed to create order: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during order creation: $e');
      return null;
    }
  }

  Future<List<Order>?> getAllOrders(String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.ORDERS}');
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => Order.fromJson(item)).toList();
      } else {
        print('Failed to get all orders: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting all orders: $e');
      return null;
    }
  }
}