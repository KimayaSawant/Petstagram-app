import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:petstagram/resources/storage_methods.dart';
import 'package:petstagram/models/user.dart' as model;
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; 
  Future<model.User> getUserDetails() async{
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }
  Future<String> signUpUser({
      required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file,
  }) async{
    String res = "Some error occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty  || file != null ){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl : photoUrl,
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);

        res= "success";
      }
    } on FirebaseAuthException catch(err){
      if(err.code == 'invalid-email'){
        res = 'Enter a valid email id';
      }

    }
      
    catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<String>loginUser({
    required String email,
    required String password,
  }) async{
   String res = "Some Error Occured.";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
      else{
        res = "Enter all the fields";
      }
    }catch(err){
      res = err.toString();

    }
    return res; // Reteun statement
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
 }