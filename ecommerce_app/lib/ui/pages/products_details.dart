import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/authentication_bloc_provider.dart';
import 'package:ecommerce_app/blocs/home/home_bloc.dart';
import 'package:ecommerce_app/blocs/home/home_bloc_provider.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/ui/widgets/carousel_products.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  final String name;
  final int price;
  final String picture1;
  final String picture2;
  final String color;
  final String size;

  const ProductDetails(
      {Key key,
      this.name,
      this.price,
      this.picture1,
      this.picture2,
      this.color,
      this.size})
      : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  AuthenticationBloc _authenticationBloc;

  HomeBloc _homeBloc;

  String _uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  // @override
  // void dispose() {
  //   _homeBloc.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              CarouselProducts(
                image1: widget.picture1,
                image2: widget.picture2,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Text(
                      "${widget.name}",
                      style: Theme.of(context).textTheme.display1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text("\$ ${widget.price}"),
                    ),
                    Spacer(),
                    Text(
                      "Color: ${widget.color}",
                      style: Theme.of(context).textTheme.headline.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Spacer(),
                    Text(
                      "Size: ${widget.size}",
                      style: Theme.of(context).textTheme.headline.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 15),
                        height: double.infinity,
                        child: RaisedButton(
                          child: Text(
                            "ADD TO CART",
                            style: Theme.of(context).textTheme.button.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          onPressed: () {
                            Product product_details = Product(
                              name: widget.name,
                              price: widget.price,
                              picture1: widget.picture1,
                              picture2: widget.picture2,
                              color: widget.color,
                              size: widget.size,
                            );
                            _homeBloc.addToCart.add(product_details);
                            Fluttertoast.showToast(msg: "Product added to cart");
                          },
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
