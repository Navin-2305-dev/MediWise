import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String role, // "doctor" or "patient"
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': email,
          'name': name,
          'role': role,
          'createdAt': Timestamp.now(),
        });

        res = "Success";
      } else {
        res = "Please fill all fields";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          res = "This email is already registered.";
        } else if (e.code == 'weak-password') {
          res = "Password is too weak.";
        } else {
          res = e.message ?? "An error occurred during sign-up.";
        }
      } else {
        res = e.toString();
      }
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
    String? expectedRole,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (expectedRole != null) {
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .doc(credential.user!.uid)
              .get();
          if (userDoc.exists && userDoc['role'] == expectedRole) {
            // Store role in SharedPreferences on successful login
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userRole', expectedRole);
            res = "success";
          } else {
            await _auth.signOut();
            res = "This account is not registered as a $expectedRole.";
          }
        } else {
          res = "success";
        }
      } else {
        res = "Please enter all fields";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          res = "Invalid email or password.";
        } else {
          res = e.message ?? "An error occurred during login.";
        }
      } else {
        res = e.toString();
      }
    }
    return res;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRole'); // Clear role on sign out
    await _auth.signOut();
  }
}
