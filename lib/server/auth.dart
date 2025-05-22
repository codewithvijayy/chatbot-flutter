import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<Auth, bool>(
  (ref) =>
      Auth(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class Auth extends StateNotifier<bool> {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Auth({required this.auth, required this.firestore})
    : super(false); // false = not loading

  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      state = true;
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = auth.currentUser;
      if (user != null) {
        final userData = {
          "FirstName": firstName,
          "LastName": lastName,
          "uid": user.uid,
          "email": email,
        };
        await firestore.collection("users").doc(user.uid).set(userData);
        return true;
      }
    } catch (e) {
      print("Signup Error: $e");
    } finally {
      state = false;
    }
    return false;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      state = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Wrong password provided.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'invalid-credential':
          return 'The credentials are invalid or have expired.';
        default:
          return 'Login failed. ${e.message}';
      }
    } catch (e) {
      print("Unexpected login error: $e");
      return 'An unexpected error occurred.';
    } finally {
      state = false;
    }
  }
}

Future<Map<String, dynamic>> getDatafromFirebaseFireStore() async {
  Map<String, dynamic>? data;
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final currentuid = auth.currentUser?.uid ?? "";
    final userdata = await firestore.collection("users").doc(currentuid).get();
    if (userdata.data() != null) {
      data = userdata.data();
    }
  } catch (e) {
    print(e.toString());
  }
  return data!;
}
