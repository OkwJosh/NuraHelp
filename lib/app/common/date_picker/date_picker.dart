import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';

import '../../utilities/constants/colors.dart';

class CustomDatePicker extends FormField<DateTime> {
  CustomDatePicker({
    Key? key,
    required String label,
    required Function(DateTime) onDateSelected,
    required bool showError,
    DateTime? initialDate,
  }) : super(
    key: key,
    initialValue: initialDate,
    validator: (value) {
      if (value == null) {
        return 'Please select a date';
      }
      return null;
    },
    builder: (FormFieldState<DateTime> state) {
      return InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: state.context,
            initialDate: initialDate ?? DateTime.now(),
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
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondaryColor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            state.didChange(picked); // Marks the field as updated
            onDateSelected(picked);  // Callback to your controller
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            errorText: state.errorText, // Shows validation error
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0.3,
                color: showError && state.hasError ? Colors.red : AppColors.black,
              ),
            ),
            suffixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              child: SvgIcon(
                AppIcons.calender,
                size: 25,
                color: AppColors.black,
              ),
            ),
          ),
          child: Text(
            state.value != null
                ? "${state.value!.day}-${state.value!.month}-${state.value!.year}"
                : '10-12-2005',
            style: TextStyle(
              color: AppColors.black,
              fontFamily: state.value != null ? 'Poppins-Regular' : 'Poppins-Light',
            ),
          ),
        ),
      );
    },
  );
}
