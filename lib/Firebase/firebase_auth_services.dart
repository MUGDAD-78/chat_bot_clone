import 'package:chat_gpt_clone/Models/firebase_model.dart';
import 'package:chat_gpt_clone/constant/alert_dilog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  register(
      {required email,
      required password,
      required username,
      required context}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      CollectionReference users =
          FirebaseFirestore.instance.collection('UserInformation');

      return users
          .doc(credential.user!.uid)
          .set(
            FirebaseModel(
                    email: email,
                    password: password,
                    userName: username,
                    uid: credential.user!.uid) // The uid of the user ..
                .convert2Map(),
          )
          .then(
            (value) => showAlertDilog(
                context, "Your account has been credited go back now"),
          )
          .catchError(
            (error) => showAlertDilog(context, "Failed to add user: $error"),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showAlertDilog(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showAlertDilog(context, 'The account already exists for that email.');
      }
    } catch (e) {
      showAlertDilog(context, e.toString());
    }
  }

  login({required emial, required password, required context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emial, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlertDilog(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showAlertDilog(context, 'Wrong password provided for that user.');
      } else {
        showAlertDilog(context, "EROOR : ${e.code}");
      }
    }
  }
}
