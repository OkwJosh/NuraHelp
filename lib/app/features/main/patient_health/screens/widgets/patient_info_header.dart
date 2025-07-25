import 'package:flutter/material.dart';
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
            CircleAvatar(),
            SizedBox(width: 10),
            Row(
              children: [
                Text(
                  'Dianne Russell',
                  style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 10),
                AppDropdown(
                  selectedValue: 'ICU',
                  menuItems: ['ICU'],
                  height: 30,
                  prefixIcon: Icons.circle,
                  showPrefixIcon: true,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 5),
        Transform.translate(
          offset: Offset(50, -8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Female',
                    style: TextStyle(
                      fontFamily: "Poppins-ExtraLight",
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_sharp, size: 10),
                  SizedBox(width: 5),
                  Text(
                    'Age 32',
                    style: TextStyle(
                      fontFamily: "Poppins-ExtraLight",
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_sharp, size: 10),
                  SizedBox(width: 5),
                  Text(
                    'O+',
                    style: TextStyle(
                      fontFamily: "Poppins-ExtraLight",
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text(
                'Gynecologic Disorders',
                style: TextStyle(
                  fontFamily: "Poppins-ExtraLight",
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
