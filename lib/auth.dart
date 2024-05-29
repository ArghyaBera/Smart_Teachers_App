import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authService{
  final auth =FirebaseAuth.instance;
  Future<void>sendLinkEmail() async{
    try{
      await auth.currentUser?.sendEmailVerification();
    }catch(e){
        print(e.toString());
    }
}
  Future<User?> createUserWithEmail(
      String Umail,String Upswd)async{
      try{
        final cred =await auth.createUserWithEmailAndPassword(email: Umail, password: Upswd);
        return cred.user;
      } on FirebaseAuthException catch(e){
        exceptionHandler(e.code);
      } catch(e){
        log('Something went wrong');
      }
      return null;
  }

  Future<User?> login(
      String Umail,String Upswd)async{
    try{
      final cred =await auth.signInWithEmailAndPassword(email:Umail, password: Upswd);
      return cred.user;
    }on FirebaseAuthException catch(e){
      exceptionHandler(e.code);
    }catch(e){
      log("Something went wrong");
    }
    return null;
  }

  Future<void> signout() async{
    try{
      await auth.signOut();
    }
    catch(e)
    {
        log("Something went wrong");
    }
    return null;
  }
}

exceptionHandler(String code){
  switch(code)
      {
    case "invalid-credential":
      log('Your Credentials are invalid');
    case "weak-password":
      log('Your password must be at least 8 characters');
    case "email-already-in-use":
      log('user already exits');
    default:
      log('Something went wrong');
  }
}