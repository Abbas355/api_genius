import 'package:get/get.dart';
import '../api_services/user_service.dart';
import '../api_services/product_service.dart';
import '../api_services/order_service.dart';
import '../controllers/user_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/order_controller.dart';

// A placeholder for the authentication token. In a real app, this would be managed securely (e.g., SharedPreferences).
String? _currentAuthToken;

void main() async {
  // Initialize GetX dependencies (services and controllers)
  // Ensure services are put first, as controllers depend on them via Get.find()
  Get.put(UserService());
  Get.put(ProductService());
  Get.put(OrderService());

  Get.put(UserController());
  Get.put(ProductController());
  Get.put(OrderController());

  // Get instances of controllers
  final UserController userController = Get.find<UserController>();
  final ProductController productController = Get.find<ProductController>();
  final OrderController orderController = Get.find<OrderController>();

  print('--- Starting API Usage Examples ---');
  print('');

  // ----------------------------------------
  // Example usage of UserController
  // Endpoints:
  // - Register User
  // - Login User
  // - Get User Profile
  // - Logout
  // ----------------------------------------
  print('--- User Controller Examples ---');

  // 1. Register User
  print('\nAttempting to register a new user...');
  await userController.registerUser(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    password: 'password123',
    passwordConfirmation: 'password123',
    phoneNumber: '1234567890',
    addressLine1: '123 Main St',
    city: 'Anytown',
    zip: '12345',
    state: 'CA',
  );
  if (userController.currentUser.value != null) {
    print('User registered: ${userController.currentUser.value}');
  } else {
    print('Registration failed: ${userController.errorMessage.value}');
  }
  print('Is loading: ${userController.isLoading.value}');

  // 2. Login User
  print('\nAttempting to login user...');
  await userController.loginUser(
    email: 'jane.smith@example.com', // Using the email from Postman example
    password: 'pass1234', // Using the password from Postman example
  );
  if (userController.authToken.value.isNotEmpty) {
    _currentAuthToken = userController.authToken.value; // Store the token for other services
    print('User logged in. Token: ${_currentAuthToken!.substring(0, 10)}...'); // Print partial token
  } else {
    print('Login failed: ${userController.errorMessage.value}');
  }
  print('Is loading: ${userController.isLoading.value}');

  // 3. Get User Profile (requires login)
  if (_currentAuthToken != null) {
    print('\nAttempting to get user profile...');
    await userController.getUserProfile();
    if (userController.currentUser.value != null) {
      print('User profile: ${userController.currentUser.value}');
    } else {
      print('Failed to get profile: ${userController.errorMessage.value}');
    }
    print('Is loading: ${userController.isLoading.value}');
  } else {
    print('\nSkipping Get User Profile as no token is available.');
  }

  // 4. Logout User
  print('\nAttempting to logout user...');
  userController.logout();
  _currentAuthToken = null; // Clear token on logout
  print('User logged out. Current user: ${userController.currentUser.value}');

  print('\n--- Product Controller Examples ---');
  // ----------------------------------------
  // Example usage of ProductController
  // Endpoints:
  // - Create Product
  // - Get All Products
  // - Get Product by ID
  // - Delete Product
  // ----------------------------------------
  // Re-login to get a token for product/order operations
  print('\nRe-logging in to acquire a token for product/order operations...');
  await userController.loginUser(
    email: 'jane.smith@example.com',
    password: 'pass1234',
  );
  if (userController.authToken.value.isNotEmpty) {
    _currentAuthToken = userController.authToken.value;
    print('Logged in successfully. Token: ${_currentAuthToken!.substring(0, 10)}...');
  } else {
    print('Failed to re-login: ${userController.errorMessage.value}');
  }

  if (_currentAuthToken != null) {
    // 1. Create Product
    print('\nAttempting to create a product...');
    await productController.createProduct(
      name: 'Smartwatch X',
      description: 'A cutting-edge smartwatch',
      price: 249.99,
      stock: 100,
      token: _currentAuthToken,
    );
    print('Is loading: ${productController.isLoading.value}');
    print('Error message: ${productController.errorMessage.value}');
    if (productController.products.isNotEmpty) {
      print('Created product (last added): ${productController.products.last}');
    }

    // 2. Get All Products
    print('\nAttempting to get all products...');
    await productController.getAllProducts();
    print('Is loading: ${productController.isLoading.value}');
    print('Error message: ${productController.errorMessage.value}');
    if (productController.products.isNotEmpty) {
      print('Fetched products count: ${productController.products.length}');
      print('First product: ${productController.products.first}');
    } else {
      print('No products fetched.');
    }

    // 3. Get Product by ID (using a dummy ID or the ID of a created product)
    print('\nAttempting to get product by ID (e.g., ID 1)...');
    int productIdToFetch = 1; // Assuming a product with ID 1 exists or was created
    if (productController.products.isNotEmpty) {
      productIdToFetch = productController.products.first.id ?? productIdToFetch;
    }
    await productController.getProductById(productIdToFetch);
    print('Is loading: ${productController.isLoading.value}');
    print('Error message: ${productController.errorMessage.value}');
    if (productController.selectedProduct.value != null) {
      print('Fetched product by ID: ${productController.selectedProduct.value}');
    } else {
      print('Product with ID $productIdToFetch not found.');
    }

    // 4. Delete Product (using a dummy ID or the ID of a created product)
    print('\nAttempting to delete a product (e.g., ID 1)...');
    int productIdToDelete = 1; // Assuming a product with ID 1 exists
    if (productController.products.isNotEmpty) {
      productIdToDelete = productController.products.first.id ?? productIdToDelete;
    }
    await productController.deleteProduct(productIdToDelete, token: _currentAuthToken);
    print('Is loading: ${productController.isLoading.value}');
    print('Error message: ${productController.errorMessage.value}');
    if (productController.products.where((p) => p.id == productIdToDelete).isEmpty) {
      print('Product with ID $productIdToDelete successfully deleted (or never existed locally).');
    } else {
      print('Product with ID $productIdToDelete deletion failed.');
    }
  } else {
    print('\nSkipping Product Controller examples as no token is available.');
  }


  print('\n--- Order Controller Examples ---');
  // ----------------------------------------
  // Example usage of OrderController
  // Endpoints:
  // - Create Order
  // - Get All Orders
  // ----------------------------------------

  if (_currentAuthToken != null) {
    // 1. Create Order
    print('\nAttempting to create an order...');
    await orderController.createOrder(
      productId: 1, // Dummy product ID
      quantity: 2,
      shippingAddress: '789 Pine St, Anytown, CA 12345',
      token: _currentAuthToken,
    );
    print('Is loading: ${orderController.isLoading.value}');
    print('Error message: ${orderController.errorMessage.value}');
    if (orderController.orders.isNotEmpty) {
      print('Created order (last added): ${orderController.orders.last}');
    }

    // 2. Get All Orders
    print('\nAttempting to get all orders...');
    await orderController.getAllOrders(token: _currentAuthToken);
    print('Is loading: ${orderController.isLoading.value}');
    print('Error message: ${orderController.errorMessage.value}');
    if (orderController.orders.isNotEmpty) {
      print('Fetched orders count: ${orderController.orders.length}');
      print('First order: ${orderController.orders.first}');
    } else {
      print('No orders fetched.');
    }
  } else {
    print('\nSkipping Order Controller examples as no token is available.');
  }

  print('\n--- End of API Usage Examples ---');
}