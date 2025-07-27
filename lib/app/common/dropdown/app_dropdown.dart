import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';

class AppDropdown extends StatefulWidget {
  AppDropdown({
    super.key,
    this.selectedValue,
    required this.menuItems,
    this.height = 35,
    this.prefixIcon,
    this.showPrefixIcon = false,
    this.prefixIconColor = Colors.purple,
    this.hintText,
  });

  String? selectedValue;
  List<String> menuItems;
  final double height;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final bool showPrefixIcon;
  final String? hintText;


  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: IntrinsicWidth(
        child: DropdownButtonFormField(
          value: widget.selectedValue,
          hint: Text(widget.hintText ?? 'Select an option',style: TextStyle(color: AppColors.greyColor.withOpacity(0.6),fontSize: 14),),
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.keyboard_arrow_down_sharp),
          ),
          iconSize: 20,
          dropdownColor: Colors.white,
          style: TextStyle(
              fontFamily: "Poppins-Light",
              fontSize: 14,
              color: Colors.black,
              overflow: TextOverflow.ellipsis
          ),
          decoration: InputDecoration(
            prefixIcon: widget.showPrefixIcon?Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: Icon(widget.prefixIcon,color: widget.prefixIconColor,size: 15,),
            ):null,
            prefixIconConstraints: BoxConstraints(
              minHeight: 30,
              maxWidth: 30,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColors.greyColor
                    .withOpacity(0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColors.greyColor
                    .withOpacity(0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: AppColors.greyColor
                    .withOpacity(0.4),
              ),
            ),
          ),
          items: widget.menuItems.map((String value,) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: "Poppins-ExtraLight",
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              widget.selectedValue = value!;
            });
          },
        ),
      ),
    );
  }
}
