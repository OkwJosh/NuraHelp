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
    this.verticalPadding = 5,
    this.borderRadius = 5,
  });

  String? selectedValue;
  List<String> menuItems;
  final double height;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final bool showPrefixIcon;
  final String? hintText;
  final double verticalPadding;
  final double borderRadius;


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
          hint: Text(widget.hintText ?? 'Select an option',style: TextStyle(color: AppColors.black,fontSize: 14,fontFamily: 'Poppins-Light')),
          icon: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.keyboard_arrow_down_sharp,color: AppColors.black,),
          ),
          iconSize: 20,
          dropdownColor: Colors.white,
          style: TextStyle(
              fontFamily: "Poppins-Light",
              fontSize: 14,
              color: AppColors.black,
              overflow: TextOverflow.ellipsis
          ),
          decoration: InputDecoration(
            prefixIcon: widget.showPrefixIcon?Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 20),
              child: Icon(widget.prefixIcon,color: widget.prefixIconColor,size: 15,),
            ):null,
            prefixIconConstraints: BoxConstraints(
              minHeight: 30,
              maxWidth: 30,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding,
              horizontal: 8
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                width: 0.3,
                  color: AppColors.black
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                width: 0.3,
                  color: AppColors.black
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                width: 0.3,
                color: AppColors.black
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
                  fontSize: 14,
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
