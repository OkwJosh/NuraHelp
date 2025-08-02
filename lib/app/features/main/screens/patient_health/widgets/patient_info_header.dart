import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../common/dropdown/app_dropdown.dart';

class PatientInfoHeader extends StatelessWidget {
  const PatientInfoHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(backgroundColor: Colors.transparent,child: SvgIcon(AppIcons.profile),),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dianne Russell',
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: 15,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Female',
                      style: TextStyle(
                        fontFamily: "Poppins-ExtraLight",
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Age 32',
                      style: TextStyle(
                        fontFamily: "Poppins-ExtraLight",
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'O+',
                      style: TextStyle(
                        fontFamily: "Poppins-ExtraLight",
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ],
          ),
      ],
    );
  }
}
