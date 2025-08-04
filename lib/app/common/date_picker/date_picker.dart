import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../utilities/constants/colors.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.label,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime(2100),
      helpText: '',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.secondaryColor),
            ),

          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: FittedBox(
            fit: BoxFit.scaleDown,
              child: SvgIcon(AppIcons.calender,size: 25,color: AppColors.black)),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
              : '20-8-2002',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: selectedDate != null?'Poppins-Regular':'Poppins-Light'
          ),
        ),
      ),
    );
  }
}
