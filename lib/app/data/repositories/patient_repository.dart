import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';

import '../../utilities/exceptions/firebase_exceptions.dart';
import '../../utilities/exceptions/platform_exceptions.dart';

class PatientRepository{
  static PatientRepository get instance => Get.find();






  Future<String> uploadImage(String path, XFile image) async{
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong.Please try again';
    }
  }


}