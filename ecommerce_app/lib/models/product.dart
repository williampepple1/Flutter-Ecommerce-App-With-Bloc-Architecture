class Product {
  String name;
  String picture1;
  String picture2;
  int price;
  String color;
  String size;

  Product(
      {this.name,
      this.picture1,
      this.picture2,
      this.price,
      this.color,
      this.size});

  factory Product.fromDoc(dynamic doc) => Product(
        name: doc["name"],
        picture1: doc["picture1"],
        picture2: doc["picture2"],
        price: (doc["price"] as num).toInt(),
        color: doc["color"],
        size: doc["size"],
      );

  toJson(Product product) => {
        'name': product.name,
        'picture1': product.picture1,
        'picture2': product.picture2,
        'price': product.price,
        'color': product.color,
        'size': product.size,
      };
}
