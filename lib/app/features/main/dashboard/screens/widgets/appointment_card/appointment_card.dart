import 'package:flutter/material.dart';

import '../../../../../../utilities/constants/colors.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Material(
        elevation: 1,
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:BoxDecoration(
                    color: AppColors.peachColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                child: Text("17\n Jun",textAlign: TextAlign.center,style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 22),),),
              Padding(
                padding: EdgeInsets.only(top: 10,left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('General Checkup',style: TextStyle(fontFamily: "Poppins-Regular",fontSize: 14),),
                    SizedBox(height: 5),
                    Text('09:00AM - 12:00PM',style: TextStyle(fontFamily: "Poppins-ExtraLight",fontSize: 14),),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 15,),
                        SizedBox(width: 5),
                        Text("Jesse Lee",style: TextStyle(fontFamily: "Poppin-Regular",fontSize: 14),)
                      ],
                    )

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
