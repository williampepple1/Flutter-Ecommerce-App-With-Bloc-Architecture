import 'package:ecommerce_app/blocs/login/login_bloc.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/authentication.dart';
import 'package:ecommerce_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Page { signin, signup }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController _fullname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  Page _selectedPage = Page.signin;
  CustomColour _customColour = CustomColour();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: isLoading == true ? Center(child: CircularProgressIndicator()) : Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  'CART.NG',
                                  style: TextStyle(
                                      color: _customColour.color1,
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 60.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _selectedPage = Page.signin;
                              });
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: _selectedPage == Page.signin
                                      ? _customColour.color1
                                      : _customColour.color2,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                          Expanded(
                              child: FlatButton(
                            onPressed: () {
                              setState(() {
                                _selectedPage = Page.signup;
                              });
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: _selectedPage == Page.signup
                                      ? _customColour.color1
                                      : _customColour.color2,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height / 1.8,
                        child: _loadScreen(context, _loginBloc),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadScreen(BuildContext context, LoginBloc _loginBloc) {
    switch (_selectedPage) {
      case Page.signup:
        return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: _fullname,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Full name",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Please make sure your email address is valid';
                            else
                              return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The password field cannot be empty";
                          } else if (value.length < 6) {
                            return "the password has to be at least 6 characters long";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      color: _customColour.color1,
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate() &&
                              _selectedPage == Page.signup) {
                             setState(() {
                                  isLoading = true;
                                });
                            User user_details = User(
                                _fullname.text, _email.text, _password.text);
                                String result = await _loginBloc.createAccount(user_details);
                                if(result != "Success"){
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(msg: "$result");
                            }  
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 90.0,
                            ),
                            Text(
                              "Sign Up",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ));
        break;

      case Page.signin:
        return Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Please make sure your email address is valid';
                            else
                              return null;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "The password field cannot be empty";
                          } else if (value.length < 6) {
                            return "the password has to be at least 6 characters long";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 10.0),
                  child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      color: _customColour.color1,
                      elevation: 0.0,
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate() &&
                              _selectedPage == Page.signin) {
                                setState(() {
                                  isLoading = true;
                                });
                            User user_details =
                                User(" ", _email.text, _password.text);
                                String result = await _loginBloc.logIn(user_details);
                            if(result != "Success"){
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(msg: "$result");
                            }                      
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 90.0,
                            ),
                            Text(
                              "Sign In",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ));
        break;
    }
  }
}
