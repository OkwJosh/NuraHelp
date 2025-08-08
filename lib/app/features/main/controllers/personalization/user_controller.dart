import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurahelp/app/data/models/patient_model.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';

import '../../../../data/repositories/patient_repository.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();


  final patientRepository = Get.put(PatientRepository());
  final imageLoading = false.obs;
  Rx<PatientModel> patient = PatientModel.empty().obs;



  uploadProfilePicture() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70,maxHeight: 512,maxWidth: 512 );
      if(image != null) {
        imageLoading.value = true;

        final imageUrl = await patientRepository.uploadImage('Patient/Profile/', image);

        // //Update user Image Record
        // Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        // await userRepository.updateSingleField(json);

        patient.value.profilePicture = imageUrl;
        patient.refresh();
        AppToasts.successSnackBar(title: 'Congratulations', message: 'Your profile image has been updated');
      }
    }catch(e){
      AppToasts.errorSnackBar(title: 'Oh Snap',message: 'Something went wrong $e');
    }
    finally{
      imageLoading.value = false;
    }
  }



}