import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, this.featureName = 'This feature'});

  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          featureName,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins-Medium',
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.update_rounded,
                  size: 60,
                  color: AppColors.secondaryColor,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Update Coming in v2',
                style: TextStyle(
                  fontFamily: 'Poppins-SemiBold',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We\'re working hard to bring you this feature. Stay tuned for the next update!',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
