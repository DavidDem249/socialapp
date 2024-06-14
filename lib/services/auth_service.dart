import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  // Google Sign In

  signInWithGoogle() async{

    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    
    // After creating the user, create a new document in cloud firestore called Users
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
      "username": userCredential.user!.email!.split('@')[0], // initial username
      "bio": "Empty bie...",
      // add any additionam fields as needed
    });

    // finaly, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }
}