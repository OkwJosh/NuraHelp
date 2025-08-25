import 'package:flutter/material.dart';

import '../../../../../common/dropdown/app_dropdown.dart';

class SymptomDropdown extends StatelessWidget {
  SymptomDropdown({
    super.key,
    required this.symptomName,
    required this.selectedValue,
    required this.menuItems,
    required this.onChanged
  });

  final String symptomName;
  String? selectedValue;
  List<String> menuItems;
  Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          symptomName,
          style: TextStyle(fontSize: 14, fontFamily: 'Poppins-Medium'),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: AppDropdown(
                menuItems: menuItems,
                selectedValue: selectedValue,
                hintText: '1-10',
                height: 50,
                validator: (String? value) {
                  return null;
                },
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
