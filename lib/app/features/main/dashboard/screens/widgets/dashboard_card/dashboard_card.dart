import 'package:flutter/material.dart';
import '../../../../../../common/rounded_containers/rounded_icon_container.dart';
import '../../../../../../utilities/constants/colors.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.6),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 10,right: 20,bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedIconContainer(),
            SizedBox(height: 5),
            Text("New Patients",style: TextStyle(fontFamily: "Poppins-Light"),),
            SizedBox(height: 10),
            Row(
              children: [
                Text("1,925",style: TextStyle(fontSize: 28,fontFamily: "Poppins-Regular"),),
                SizedBox(width: 50),
                Row(
                  children: [
                    Icon(Icons.arrow_drop_up_outlined,color: Colors.green,weight: 10,size: 40,),
                    Text("+ 201",style: TextStyle(color: Colors.green,fontFamily: "Poppins-SemiBold",fontWeight: FontWeight.w500),)
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


