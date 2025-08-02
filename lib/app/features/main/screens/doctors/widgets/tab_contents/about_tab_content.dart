import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
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
        SizedBox(height: 0),
        AboutInfoColumn(headerText:'General information',bodyText:AppTexts.loremIpsumText,icon:SvgIcon(AppIcons.file),),
        AboutInfoColumn(headerText:'Current working place',bodyText:'Mercy Heart Institute,123 Main St,Boston',icon: SvgIcon(AppIcons.hospital)),
        AboutInfoColumn(headerText:'Education',bodyText:'Doctor of Medicine (MD), Johns Hopkins University',icon:SvgIcon(AppIcons.mortarBoard)),
        AboutInfoColumn(headerText:'Certification',bodyText:'Board-certified in Cardiology by the American Board of Internal Medicine.',icon: SvgIcon(AppIcons.diploma)),
        AboutInfoColumn(headerText:'Training',bodyText:'Completed residency and advanced cardiology fellowship at the Cleveland Clinic.',icon:SvgIcon(AppIcons.note)),
        AboutInfoColumn(headerText:'Licensure',bodyText:'Fully licensed to practice medicine and cardiology in multiple states, adhering to the latest professional standards.',icon:SvgIcon(AppIcons.certificate),),
        AboutInfoColumn(headerText:'Experience',bodyText:'Over 12 years of clinical practice, specializing in preventive care, advanced cardiac imaging, and heart failure management.',icon:SvgIcon(AppIcons.stethoscope)),

      ],
    );
  }
}


