import 'package:ecommerce_app/ui/pages/products_details.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final int price;
  final String picture1;
  final String picture2;
  final String color;
  final String size;

  ProductCard({
    @required this.name,
    @required this.price,
    @required this.picture1,
    @required this.picture2,
    @required this.color,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetails(
                      name: name,
                      price: price,
                      picture1: picture1,
                      picture2: picture2,
                      color: color,
                      size: size,)));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(62, 168, 174, 201),
                offset: Offset(0, 9),
                blurRadius: 14,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: <Widget>[
                Image.network(
                  picture1,
                  height: 220,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(                      
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.025),
                          ],
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container())),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '$name \n', style: TextStyle(fontSize: 18)),
                        TextSpan(
                            text: '\$${price.toString()} \n',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ]))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
