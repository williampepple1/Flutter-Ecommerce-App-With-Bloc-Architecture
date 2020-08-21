import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/authentication_bloc_provider.dart';
import 'package:ecommerce_app/blocs/home/home_bloc.dart';
import 'package:ecommerce_app/blocs/home/home_bloc_provider.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
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

  AuthenticationBloc _authenticationBloc;

  HomeBloc _homeBloc;

  String _uid;

  int total = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Cart",
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 15),
          Expanded(
            child: StreamBuilder(
              stream: _homeBloc.listCartProduct,
              builder: ((BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                total += snapshot.data[index].price;
                return Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: Image.network(
                            "${snapshot.data[index].picture1}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${snapshot.data[index].name}",
                              style: Theme.of(context).textTheme.title,
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "\$ ${snapshot.data[index].price}",
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          
                } else {
                  return Center(
                    child: Container(
                      child: Text('No Products in cart'),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
