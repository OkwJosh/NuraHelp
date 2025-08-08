import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/app_service.dart';
import 'package:nurahelp/app/utilities/exceptions/firebase_auth_exceptions.dart';
import 'package:nurahelp/app/utilities/exceptions/firebase_exceptions.dart';
import 'package:nurahelp/app/utilities/exceptions/format_exceptions.dart';
import 'package:nurahelp/app/utilities/exceptions/platform_exceptions.dart';



class AuthenticationRepository {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  User? get authUser => _auth.currentUser;



  Future<UserCredential> loginWithEmailAndPassword(String email,
      String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw AppFormatException();
    }
    on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again';
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(String email,
      String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw AppFormatException();
    }
    on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again';
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw AppFormatException();
    }
    on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again';
    }
  }



}
