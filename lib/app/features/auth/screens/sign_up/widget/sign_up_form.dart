import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/common/date_picker/date_picker.dart';
import '../../../../../utilities/constants/colors.dart';
import '../../../../../utilities/validators/validation.dart';
import '../../../controllers/sign_up_controllers/sign_up_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.put(SignUpController());

    bool showDatePickerError = (signUpController.isSubmitted.value && signUpController.submittedDate == null);
    return Form(
      key: signUpController.signUpFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: signUpController.fullName,
            validator: (value) => AppValidator.validateTextField('Name', value?.trim()),
            decoration: InputDecoration(hintText: 'John Doe'),
            cursorColor: AppColors.black,
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: signUpController.email,
            validator: (value) => AppValidator.validateEmail(value?.trim()),
            decoration: InputDecoration(hintText: 'example@gmail.com'),
            cursorColor: AppColors.black,
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: signUpController.phoneNumber,
            validator: (value) =>
                AppValidator.validatePhoneNumber(value?.trim()),
            decoration: InputDecoration(hintText: '09123639400'),
            cursorColor: AppColors.black,
          ),
          SizedBox(height: 12),
          CustomDatePicker(label: '', onDateSelected: (date) {
            signUpController.submittedDate.value = date;
          },showError: showDatePickerError),
          SizedBox(height: 12),
          Obx(() {
            return TextFormField(
              controller: signUpController.password,
              validator: (value) => AppValidator.validatePassword(value?.trim()),
              cursorColor: AppColors.black,
              obscureText: signUpController.hidePassword.value,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                hintText: 'Create password',
                suffixIcon: IconButton(
                  icon: signUpController.hidePassword.value
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility_outlined),
                  onPressed: () => signUpController.hidePassword.value =
                      !signUpController.hidePassword.value,
                ),
              ),
            );
          }),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 20,
                child: Obx(
                  () {
                    bool showCheckboxError =
                        (signUpController.isSubmitted.value &&
                            !signUpController.nuraAICheckboxIsClicked.value) ||
                            (signUpController.isSubmitted.value &&
                                !signUpController.consentCheckboxIsClicked.value);
                    return Checkbox(
                      isError: showCheckboxError,
                      value: (signUpController.consentCheckboxIsClicked.value),
                      onChanged: (value) {
                        signUpController.consentCheckboxIsClicked.value = value!;
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Doctor-Patient Sharing Consent',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 20,
                child: Obx(
                  (){
                    bool showCheckboxError =
                        (signUpController.isSubmitted.value &&
                            !signUpController.nuraAICheckboxIsClicked.value) ||
                            (signUpController.isSubmitted.value &&
                                !signUpController.consentCheckboxIsClicked.value);
                    return Checkbox(
                      isError: showCheckboxError,
                      value: (signUpController.nuraAICheckboxIsClicked.value),
                      onChanged: (value) {
                        signUpController.nuraAICheckboxIsClicked.value = value!;
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Nura AI Access to Personal Data',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.black,
                  fontFamily: 'Poppins-Regular',
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                signUpController.isSubmitted.value = true;
                signUpController.signUpWithEmailAndPassword();
              },
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins-Medium',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
