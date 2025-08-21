import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/features/main/screens/settings/settings.dart';
import '../../../../common/shimmer/shimmer_effect.dart';
import '../../../../common/textfield/textfield_with_header.dart';
import '../../../../utilities/constants/colors.dart';
import '../../../../utilities/constants/icons.dart';
import '../../../../utilities/constants/svg_icons.dart';

class EditPersonalInformation extends StatelessWidget {
  const EditPersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<PatientController>();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _controller.editName.text = _controller.patient.value.name;
      _controller.editEmail.text = _controller.patient.value.email;
      _controller.editPhone.text = _controller.patient.value.phone;
    });
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.offAll(() => SettingsScreen()),
                    icon: Icon(Icons.arrow_back_ios),
                  ),
                  Text('Edit Personal Info', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 90,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Material(
                      elevation: 1,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Column(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Obx(
                            () => Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: _controller.imageLoading.value
                                            ? AppShimmerEffect(
                                          height: 130,
                                          width: 130,
                                          radius: 130,
                                        )
                                            : _controller.patient.value.profilePicture!.isEmpty?Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: CircleAvatar(
                                              radius: 60,
                                              backgroundColor: Colors.white,
                                              child: SvgIcon(
                                                AppIcons.profile,
                                                size: 100,
                                              ),
                                            ),
                                          ),
                                        ):SizedBox(
                                          height: 130,
                                          width: 130,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(90),
                                            child: Image.network(
                                              _controller.patient.value.profilePicture!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () => _controller.uploadProfilePicture(),
                                    child: Text(
                                      'Change Profile Picture',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        color: AppColors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // TextFieldWithHeader(headerText: 'Full Name'),
                            // TextFieldWithHeader(headerText: 'Date of Birth'),
                            // TextFieldWithHeader(headerText: 'Phone Number'),
                            // TextFieldWithHeader(headerText: 'Email Address'),
                            TextFormField(
                              controller: _controller.editName,
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                              ),
                            ),
                            TextFormField(
                              controller: _controller.editEmail,
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                            ),
                            TextFormField(
                              controller: _controller.editPhone,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                              ),
                            ),

                            SizedBox(height: 15),
                            SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                onPressed: () => _controller.savePersonalInfo(),
                                child: Text(
                                  'Save and Update',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
