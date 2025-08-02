import 'package:flutter/material.dart';
import '../../utilities/constants/colors.dart';

class CustomSwitch extends StatefulWidget {
  CustomSwitch({
    super.key,
    required this.firstOptionText,
    required this.secondOptionText,
    this.thirdOptionText = '',
    this.numberOfOptions = 2,
    this.firstOptionActive = true,
    this.secondOptionActive = false,
    this.thirdOptionActive = false,
  });

  final String firstOptionText;
  final String secondOptionText;
  final String thirdOptionText;
  final int numberOfOptions;
  bool firstOptionActive;
  bool secondOptionActive;
  bool thirdOptionActive;

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black,width: 0.3),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          /// FIRST OPTION
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.firstOptionActive = true;
                  widget.secondOptionActive = false;
                  widget.thirdOptionActive = false;
                });
              },
              style: TextButton.styleFrom(
                overlayColor: AppColors.black300,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                backgroundColor: widget.firstOptionActive
                    ? AppColors.greyColor.withOpacity(0.1)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              child: Text(
                widget.firstOptionText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: "Poppins-ExtraLight",
                ),
              ),
            ),
          ),

          /// SECOND OPTION
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  widget.firstOptionActive = false;
                  widget.secondOptionActive = true;
                  widget.thirdOptionActive = false;
                });
              },
              style: TextButton.styleFrom(
                overlayColor: AppColors.black300,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding:EdgeInsets.zero,
                backgroundColor: widget.secondOptionActive
                    ? AppColors.greyColor.withOpacity(0.1)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: widget.numberOfOptions == 2
                      ? BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )
                      : BorderRadius.zero,
                ),
              ),
              child: Text(
                widget.secondOptionText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: "Poppins-ExtraLight",
                ),
              ),
            ),
          ),

          /// THIRD OPTION (Optional)
          if (widget.numberOfOptions == 3)
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    widget.firstOptionActive = false;
                    widget.secondOptionActive = false;
                    widget.thirdOptionActive = true;
                  });
                },
                style: TextButton.styleFrom(
                  overlayColor: AppColors.black300,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  backgroundColor: widget.thirdOptionActive
                      ? AppColors.greyColor.withOpacity(0.1)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  widget.thirdOptionText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: "Poppins-ExtraLight",
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
