import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import '../models/product.dart';

class ProductService {
  final String _baseUrl = ApiConstants.BASE_URL;

  Future<Product?> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String token,
  }) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.PRODUCTS}');
      var request = http.MultipartRequest('POST', uri)
        ..fields['name'] = name
        ..fields['description'] = description
        ..fields['price'] = price.toString()
        ..fields['stock'] = stock.toString();

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      final http.StreamedResponse streamedResponse = await request.send();
      final http.Response response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Product.fromJson(jsonResponse);
      } else {
        print('Failed to create product: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during product creation: $e');
      return null;
    }
  }

  Future<List<Product>?> getAllProducts() async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.PRODUCTS}');
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((item) => Product.fromJson(item)).toList();
      } else {
        print('Failed to get all products: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting all products: $e');
      return null;
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.PRODUCTS_BY_ID}$id');
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return Product.fromJson(jsonResponse);
      } else {
        print('Failed to get product by ID: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  Future<bool> deleteProduct(int id, String token) async {
    try {
      final Uri uri = Uri.parse('$_baseUrl${ApiConstants.PRODUCTS_BY_ID}$id');
      final http.Response response = await http.delete(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete product: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
}