import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:esame/features/authentification/model/login_model.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  User? get currentUser => _auth.currentUser;


  bool get isLoggedIn => _auth.currentUser != null;

  Future<String?> loginUser(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');
      isLoading = false;
      notifyListeners();
      
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'The email address is invalid.';
        case 'user-disabled':
          return 'The user account has been disabled.';
        case 'invalid-credential':
          return 'Invalid email or password.';
        default:
          return e.message ?? 'An unknown error occurred';
      }
    } catch (e) {
      print('Login Error: $e');
      isLoading = false;
      notifyListeners();
      return 'An unexpected error occurred';
    }
  }


  Future<String?> resetPassword(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      
      isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      print('Reset Password Error: ${e.code} - ${e.message}');
      isLoading = false;
      notifyListeners();
      
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'invalid-email':
          return 'The email address is invalid.';
        default:
          return e.message ?? 'An unknown error occurred';
      }
    } catch (e) {
      print('Reset Password Error: $e');
      isLoading = false;
      notifyListeners();
      return 'An unexpected error occurred';
    }
  }


  Future<void> updateProfileImage(String imageUrl) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePhotoURL(imageUrl);
        await _auth.currentUser!.reload();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }


  Future<void> updateDisplayName(String name) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateDisplayName(name);
        await _auth.currentUser!.reload();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating display name: $e');
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}

