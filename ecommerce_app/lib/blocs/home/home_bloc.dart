import 'dart:async';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/authentication_api.dart';
import 'package:ecommerce_app/services/db_firestore_api.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  final BehaviorSubject<List<Product>> _productController =
      BehaviorSubject<List<Product>>();
  Sink<List<Product>> get _addListProduct => _productController.sink;
  Stream<List<Product>> get listProduct => _productController.stream;

  final StreamController<Product> _addProductController =
      BehaviorSubject<Product>();
  Sink<Product> get _addProduct =>  _addProductController.sink;
  Stream<Product> get getProduct =>  _addProductController.stream;


  final BehaviorSubject<List<Product>> _cartProductController =
      BehaviorSubject<List<Product>>();
  Sink<List<Product>> get _addCartProduct => _cartProductController.sink;
  Stream<List<Product>> get listCartProduct => _cartProductController.stream;

  final StreamController<Product> _addToCartController =
      BehaviorSubject<Product>();
  Sink<Product> get addToCart =>  _addToCartController.sink;
  Stream<Product> get getCart =>  _addToCartController.stream;

  HomeBloc(this.dbApi, this.authenticationApi) {
    _startListeners();
    _addProductController.stream.listen(addProductToDb);
    _addToCartController.stream.listen(addProductToCart);

  }

  Future<String> addProductToDb(Product product) async {
    dbApi.addProduct(product);
  }

  Future<String> addProductToCart(Product product) async {
    authenticationApi.getFirebaseAuth().currentUser().then((user) {
    dbApi.addProductToCart(user.uid.toString(), product);
    });
  }

  void _startListeners() {
    authenticationApi.getFirebaseAuth().currentUser().then((user) {
      dbApi.getProductList().listen((productDocs) {
        _addListProduct.add(productDocs);
        print(productDocs);
      });
      print(user.uid);

      dbApi.getCartList(user.uid.toString()).listen((productDocs) {
        _addCartProduct.add(productDocs);
        print(productDocs);
      });
    });
  }

  // void _getCartProducts 

  void dispose() {
    _productController.close();
    _addProductController.close();
    _cartProductController.close();
    _addToCartController.close();
  }
}
