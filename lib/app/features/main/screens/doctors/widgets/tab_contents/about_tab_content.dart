import 'package:flutter/material.dart';
import '../../../../../../utilities/constants/colors.dart';
import '../../../../../../utilities/constants/texts.dart';
import '../about_info.dart';

class AboutTabContent extends StatelessWidget {
  const AboutTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        SizedBox(height: 10),
        AboutInfoColumn(headerText:'General information',bodyText:AppTexts.loremIpsumText,icon:Icon(Icons.note_alt_outlined,color: AppColors.secondaryColor),),
        AboutInfoColumn(headerText:'Current working place',bodyText:'Mercy Heart Institute,123 Main St,Boston',icon:Icon(Icons.apartment_outlined,color: AppColors.secondaryColor),),
        AboutInfoColumn(headerText:'Education',bodyText:'Doctor of Medicine (MD), Johns Hopkins University',icon:Icon(Icons.school_outlined,color: AppColors.secondaryColor),),
        AboutInfoColumn(headerText:'Certification',bodyText:'Board-certified in Cardiology by the American Board of Internal Medicine.',icon:Icon(Icons.book_outlined,color: AppColors.secondaryColor),),
        AboutInfoColumn(headerText:'Training',bodyText:'Completed residency and advanced cardiology fellowship at the Cleveland Clinic.',icon:Icon(Icons.model_training_outlined,color: AppColors.secondaryColor),),
        AboutInfoColumn(headerText:'Licensure',bodyText:'Fully licensed to practice medicine and cardiology in multiple states, adhering to the latest professional standards.',icon:Icon(Icons.credit_card_outlined,color: AppColors.secondaryColor),),
        AboutInfoColumn(headerText:'Experience',bodyText:'Over 12 years of clinical practice, specializing in preventive care, advanced cardiac imaging, and heart failure management.',icon:Icon(Icons.timelapse_outlined,color: AppColors.secondaryColor),),

      ],
    );
  }
}


