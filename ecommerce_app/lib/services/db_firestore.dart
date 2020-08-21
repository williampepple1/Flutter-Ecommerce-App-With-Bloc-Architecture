import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  Firestore _firestore = Firestore.instance;
  String _collectionProducts = 'products';
  String _collectionsUsers = 'users';

  Stream<List<Product>> getProductList() {
    return _firestore
        .collection(_collectionProducts)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Product> _productDocs =
          snapshot.documents.map((doc) => Product.fromDoc(doc)).toList();
      return _productDocs;
    });
  }

  Future<bool> addProduct(Product product) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionProducts).add({
      'name': product.name,
      'picture1': product.picture1,
      'picture2': product.picture2,
      'price': product.price,
      'color': product.color,
      'size': product.size,
    });
    return _documentReference.documentID != null;
  }

  Future<void> addProductToCart(String uid, Product product) async {
    DocumentSnapshot doc =
        await _firestore.collection(_collectionsUsers).document(uid).get();
    List<Product> cartList = doc.data["cart"] != null
        ? (doc.data["cart"] as List)
            .map((product) => Product.fromDoc(product))
            .toList()
        : null;
    if (cartList != null) {
      cartList.add(product);
      List<dynamic> cartMap =
          cartList.map((product) => Product().toJson(product)).toList();
      await _firestore
          .collection(_collectionsUsers)
          .document(uid)
          .updateData({'cart': cartMap});
    } else {
      await _firestore.collection(_collectionsUsers).document(uid).updateData({
        'cart': [{
          'name': product.name,
          'picture1': product.picture1,
          'picture2': product.picture2,
          'price': product.price,
          'color': product.color,
          'size': product.size,
        }]
      });
    }
  }

  Stream<List<Product>> getCartList(String uid) {
    return _firestore
        .collection(_collectionsUsers)
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      List<Product> cart = snapshot.data["cart"] != null
          ? (snapshot.data["cart"] as List)
              .map((product) => Product.fromDoc(product))
              .toList()
          : null;
      return cart;
    });
  }
}
