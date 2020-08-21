import 'package:ecommerce_app/models/product.dart';

abstract class DbApi {
  Stream<List<Product>> getProductList();
  Stream<List<Product>> getCartList(String uid);
  Future<bool> addProduct(Product product);
  Future<void> addProductToCart(String uid, Product product);
}
