import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/authentication_bloc_provider.dart';
import 'package:ecommerce_app/blocs/home/home_bloc.dart';
import 'package:ecommerce_app/blocs/home/home_bloc_provider.dart';
import 'package:ecommerce_app/ui/pages/add_product.dart';
import 'package:ecommerce_app/ui/widgets/product_card.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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

  List<Map<String, dynamic>> items = [
    {
      "name": "Mother Board",
      "price": 200.00,
      "picture1":
          "https://firebasestorage.googleapis.com/v0/b/testapps-2e3a3.appspot.com/o/michael-dziedzic-AsF0Nadbb18-unsplash.jpg?alt=media&token=227671d0-c468-4803-8fb8-31a1723f51dd",
      "picture2":
          "https://firebasestorage.googleapis.com/v0/b/testapps-2e3a3.appspot.com/o/nicolas-thomas-CBydtQDjaJc-unsplash.jpg?alt=media&token=121c3f1d-86aa-40be-9c35-d27c90e16aab",
      "color": "Red",
      "size": "Large"
    },
    {
      "name": "Iphone 8",
      "price": 500.00,
      "picture1":
          "https://firebasestorage.googleapis.com/v0/b/testapps-2e3a3.appspot.com/o/austin-distel-fEedoypsW_U-unsplash.jpg?alt=media&token=6ea5fc85-6214-4a15-a6d0-9691ef683ec7",
      "picture2":
          "https://firebasestorage.googleapis.com/v0/b/testapps-2e3a3.appspot.com/o/roberto-cortese-9tYbOIpVcn4-unsplash.jpg?alt=media&token=c1b55a4a-7475-422e-bde9-6200a0ca8e72",
      "color": "Black",
      "size": "Small"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10.0),
            FlatButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddProduct() ));
              },
              icon: Icon(Icons.add),
              label: Text("PRODUCTS",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),
            SizedBox(width: 10.0),
          ],
        ),
        Divider(color: Colors.black),
        SizedBox(height: 10.0),
        Flexible(
          child: StreamBuilder(
            stream: _homeBloc.listProduct,
            builder: ((BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 0.7),
                  itemBuilder: (BuildContext context, int index) {
                    return ProductCard(
                      name: snapshot.data[index].name,
                      price: snapshot.data[index].price,
                      picture1: snapshot.data[index].picture1,
                      picture2: snapshot.data[index].picture2,
                      color: snapshot.data[index].color,
                      size: snapshot.data[index].size,
                    );
                  },
                );
              } else {
                return Center(
                  child: Container(
                    child: Text('No Products Added'),
                  ),
                );
              }
            }),
          ),
        )
      ]),
    );
  }
}
