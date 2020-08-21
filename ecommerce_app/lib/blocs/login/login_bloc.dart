import 'dart:async';

import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/authentication_api.dart';

class LoginBloc {
  final AuthenticationApi authenticationApi;
  final StreamController<User> _signUpController = StreamController<User>();
  Sink<User> get signUpUser => _signUpController.sink;
  Stream<User> get signedUpUser => _signUpController.stream;
  final StreamController<User> _signInController = StreamController<User>();
  Sink<User> get signInUser => _signInController.sink;
  Stream<User> get signedInUser => _signInController.stream;

  LoginBloc(this.authenticationApi) {
    _signUpController.stream.listen(createAccount);
    _signInController.stream.listen(logIn);
  }

  Future<String> createAccount(User _user) async {
    String _result = '';
    await authenticationApi
        .createUserWithEmailAndPassword(
            fullname: _user.fullname,
            email: _user.email,
            password: _user.password)
        .then((user) {
      print('Created user: $user');
      _result = 'Success';
      authenticationApi
          .signInWithEmailAndPassword(
              email: _user.email, password: _user.password)
          .then((user) {})
          .catchError((error) async {
        print('Login error: $error');
        String _errorString = error.toString();
        int length = _errorString.length;
        _result = _errorString.substring(46, (length - 7));
      });
    }).catchError((error) async {
      print('Creating user error: $error');
       String _errorString = error.toString();
        int length = _errorString.length;
        _result = _errorString.substring(46, (length - 7));
    });
    return _result;
  }

  Future<String> logIn(User user) async {
    String _result = '';
    await authenticationApi
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((user) {
      _result = 'Success';
    }).catchError((error) {
      print('Login error: $error');
      String _errorString = error.toString();
      int length = _errorString.length;
      _result = _errorString.substring(40, (length - 7));
    });
    return _result;
  }

  void dispose() {
    _signUpController.close();
    _signInController.close();
  }
}
