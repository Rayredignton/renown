import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
 final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  User? _user;

  User? get user => _user;

AuthViewModel () {
    _firebaseAuth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign up method
  Future<void> signUp(String email, String password, String displayName) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update user profile with display name
    await userCredential.user!.updateProfile(displayName: displayName);
    await userCredential.user!.reload();
    FirebaseAuth.instance.currentUser!.reload();

    // Store user information in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'displayName': displayName,
      'uid': userCredential.user!.uid,
    });
  } catch (e) {
    print('Error during sign-up: $e');
  }
}


  // Sign in method
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _user = null;
    notifyListeners();
  }
}