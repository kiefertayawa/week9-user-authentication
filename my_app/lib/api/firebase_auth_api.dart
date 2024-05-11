import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthApi {
  late FirebaseAuth auth;
  late FirebaseFirestore firestore;

  FirebaseAuthApi() {
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
  }

  Stream<User?> fetchUser() {
    return auth.authStateChanges();
  }

  User? getUser() {
    return auth.currentUser;
  }

  Future<String?> signUp(String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });

    } on FirebaseException catch(e) {
      return (e.code);
    } catch(e) {
      return ('Error: $e');
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      print(credentials);
      return "Success";
    } on FirebaseException catch(e) {
      return (e.code);
    } catch(e) {
      return ('Error: $e');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

}