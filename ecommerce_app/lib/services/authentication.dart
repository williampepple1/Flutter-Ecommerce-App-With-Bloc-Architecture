import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/authentication_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<String> currentUserUid() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      {String fullname, String email, String password}) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    _firestore.collection("users").document(result.user.uid).setData({
      'uid': result.user.uid,
      'email': email,
      'password': password,
    });
    return result.user.uid;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
