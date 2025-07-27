import 'package:flutter/material.dart';

import '../../../../../common/dropdown/app_dropdown.dart';


class SymptomDropdown extends StatelessWidget {
  const SymptomDropdown({
    super.key, required this.symptomName,
  });

  final String symptomName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(symptomName,style: TextStyle(fontSize: 12,fontFamily: 'Poppins-Regular')),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: AppDropdown(
                menuItems: [
                  for(int i = 0; i <10; i++)
                    (i+1).toString()
                ],
                selectedValue: null,
                hintText: '1-10',
                height: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}