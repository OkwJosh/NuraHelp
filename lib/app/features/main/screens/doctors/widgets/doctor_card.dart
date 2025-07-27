import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:nurahelp/app/features/main/screens/doctors/about_doctor.dart';
import '../../../../../utilities/constants/colors.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 0.1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.secondaryColor,
                    ),
                    width: 150,
                    height: 150,
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 20,
                              color: AppColors.secondaryColor,
                            ),
                            SizedBox(width: 5),
                            Text('5.0')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. Mia Miller',style: TextStyle(fontFamily: "Poppins-Regular")),
                  Text('Pediatrician',style: TextStyle(fontFamily: "Poppins-ExtraLight",fontSize: 12)),
                ],
              ),
              Transform.translate(
                offset: Offset(15, 100),
                child: SizedBox(
                    height:50,
                    width: 50,
                    child: ElevatedButton(onPressed: () => Get.to(()=>AboutDoctorScreen()), child: Iconify(Carbon.arrow_up_right,color: Colors.white,size: 25,))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
