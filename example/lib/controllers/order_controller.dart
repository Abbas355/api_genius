import 'package:get/get.dart';
import '../api_services/order_service.dart';
import '../models/order.dart';

class OrderController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();
  final String _dummyToken = "dummy_auth_token_for_order_operations"; // Use a real token from UserController if available

  final RxList<Order> orders = <Order>[].obs;
  final Rx<Order?> selectedOrder = Rx<Order?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> createOrder({
    required int productId,
    required int quantity,
    required String shippingAddress,
    String? token, // Allow passing token, fallback to dummy
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final Order? order = await _orderService.createOrder(
        productId: productId,
        quantity: quantity,
        shippingAddress: shippingAddress,
        token: token ?? _dummyToken,
      );
      if (order != null) {
        orders.add(order);
        print('Order created successfully: ${order.id}');
      } else {
        errorMessage.value = 'Order creation failed.';
        print('Error: Order creation failed.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during order creation.';
      print('Error creating order: $e');
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllOrders({String? token}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Order>? fetchedOrders = await _orderService.getAllOrders(token ?? _dummyToken);
      if (fetchedOrders != null) {
        orders.assignAll(fetchedOrders);
        print('Fetched ${orders.length} orders.');
      } else {
        errorMessage.value = 'Failed to fetch orders.';
        print('Error: Failed to fetch orders.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred fetching orders.';
      print('Error fetching orders: $e');
    }
    finally {
      isLoading.value = false;
    }
  }
}