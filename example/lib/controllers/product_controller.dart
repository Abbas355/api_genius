import 'package:get/get.dart';
import '../api_services/product_service.dart';
import '../models/product.dart';

class ProductController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final String _dummyToken = "dummy_auth_token_for_product_operations"; // Use a real token from UserController if available

  final RxList<Product> products = <Product>[].obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Optionally fetch all products on controller initialization
    // getAllProducts();
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    String? token, // Allow passing token, fallback to dummy
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final Product? product = await _productService.createProduct(
        name: name,
        description: description,
        price: price,
        stock: stock,
        token: token ?? _dummyToken,
      );
      if (product != null) {
        products.add(product); // Add to the list
        print('Product created successfully: ${product.name}');
      } else {
        errorMessage.value = 'Product creation failed.';
        print('Error: Product creation failed.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred during product creation.';
      print('Error creating product: $e');
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Product>? fetchedProducts = await _productService.getAllProducts();
      if (fetchedProducts != null) {
        products.assignAll(fetchedProducts);
        print('Fetched ${products.length} products.');
      } else {
        errorMessage.value = 'Failed to fetch products.';
        print('Error: Failed to fetch products.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred fetching products.';
      print('Error fetching products: $e');
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> getProductById(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final Product? product = await _productService.getProductById(id);
      if (product != null) {
        selectedProduct.value = product;
        print('Fetched product by ID: ${product.name}');
      } else {
        errorMessage.value = 'Product with ID $id not found.';
        print('Error: Product with ID $id not found.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred fetching product by ID.';
      print('Error fetching product by ID: $e');
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id, {String? token}) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final bool success = await _productService.deleteProduct(id, token ?? _dummyToken);
      if (success) {
        products.removeWhere((product) => product.id == id);
        selectedProduct.value = null; // Clear selected product if it was the one deleted
        print('Product with ID $id deleted successfully.');
      } else {
        errorMessage.value = 'Failed to delete product with ID $id.';
        print('Error: Failed to delete product with ID $id.');
      }
    } catch (e) {
      errorMessage.value = 'An error occurred deleting product.';
      print('Error deleting product: $e');
    }
    finally {
      isLoading.value = false;
    }
  }
}