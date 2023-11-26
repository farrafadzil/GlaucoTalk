import 'package:apptalk/firebase/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Sign In
  Future<UserCredential> signInWithEmailandPassword(String email,
      String password) async {
    try {
      // sign in
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password);

      //add any document for the user in users collection if doesnt already
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    }
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Register
  Future <User?> registerUserWithEmailandPassword(String name, String email,
      String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      //user.uid;

      // call our database service to update the user data
      await DatabaseService().updateUserData(name, email, password);

      // After creating user, create a new document for the users in user collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Error during registration: ${e.message}");
      return null;
    }
  }


  // Google sign in
  Future<User?> signInWithGoogle() async {
    try {
      // begin interactive sign in process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

      // create a new credential for user
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      //FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
      final UserCredential authResult =
      await _firebaseAuth.signInWithCredential(credential);
      final User? user = authResult.user;

      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (!userDoc.exists) {
        // create a new firestore documeent for google sign in user
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
        });
      }

      print('User signed in with Google: ${user.displayName}');
      return user;
    }
    catch (error) {
      // Handle sign in failure
      print('Google Sign-In Error: $error');
      return null;
    }

  }
  Future<void> signOut()async{
    return await FirebaseAuth.instance.signOut();
  }
}
