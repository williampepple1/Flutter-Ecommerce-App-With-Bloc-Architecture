import 'package:ecommerce_app/blocs/authentication/authentication_bloc.dart';
import 'package:ecommerce_app/blocs/authentication/authentication_bloc_provider.dart';
import 'package:ecommerce_app/blocs/home/home_bloc.dart';
import 'package:ecommerce_app/blocs/home/home_bloc_provider.dart';
import 'package:ecommerce_app/ui/pages/cart.dart';
import 'package:ecommerce_app/ui/pages/products.dart';
import 'package:ecommerce_app/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  CustomColour _customColour = CustomColour();

  final List<Widget> _children = [
    Text('T'),
    Products(),
    Cart(),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              'CART.NG',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )),
          ],
        ),
      ),
      body: _children[_currentIndex],
      //  _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app), title: Text('Sign Out')),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_cart),
            title: new Text('Cart'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    if (index != 0) {
      setState(() {
        _currentIndex = index;
      });
    } else if (index == 0) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("No"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Yes"),
        onPressed: () async {
          _authenticationBloc.logoutUser.add(true);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Sign Out"),
        content: Text("Are you sure you really want to sign out?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}
