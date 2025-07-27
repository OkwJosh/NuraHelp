import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../../../../common/button/custom_arrow_button.dart';
import '../../../../../../common/rounded_containers/rounded_container.dart';
import '../../../../../../utilities/constants/colors.dart';

class OverviewTabContent extends StatelessWidget {
  const OverviewTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedContainer(
              child: Text(
                'Today',
                style: TextStyle(fontFamily: 'Poppins-Regular', fontSize: 12),
              ),
            ),
            SizedBox(width: 15),
            CustomArrowButton(icon: Icons.arrow_back_ios_sharp),
            SizedBox(width: 5),
            Text('17 Jul 2024'),
            SizedBox(width: 5),
            CustomArrowButton(icon: Icons.arrow_forward_ios_sharp),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 85,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    side: BorderSide(
                      color: AppColors.greyColor.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins-Light",
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 15,
              bottom: 15,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    RoundedContainer(
                      child: Row(
                        children: [
                          Icon(Symbols.heart_plus_sharp),
                          SizedBox(width: 10),
                          Text('Vitals'),
                        ],
                      ),
                      padding: 10,
                      borderRadius: 10,
                    ),
                    SizedBox(width: 15),
                    RoundedContainer(
                      padding: 10,
                      child: Text(
                        'June 17 ,2024',
                        style: TextStyle(fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('120 mg/dt', style: TextStyle(fontSize: 14)),
                        Text(
                          'Blood glucose level',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor.withOpacity(0.8),
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('55 Kg', style: TextStyle(fontSize: 14)),
                        Text(
                          'Weight',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor.withOpacity(0.8),
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('70 bpm', style: TextStyle(fontSize: 14)),
                        Text(
                          'Heart rate',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor.withOpacity(0.8),
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 85),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('71%', style: TextStyle(fontSize: 14)),
                        Text(
                          'Oxygen saturation',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor.withOpacity(0.8),
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('98.1 F', style: TextStyle(fontSize: 14)),
                        Text(
                          'Body temperature',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor.withOpacity(0.8),
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('120/80 mmhg', style: TextStyle(fontSize: 14)),
                        Text(
                          'Blood pressure',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.greyColor.withOpacity(0.8),
                            fontFamily: 'Poppins-Regular',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.greyColor.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 15,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RoundedContainer(
                      child: Row(
                        children: [
                          Icon(Icons.paste),
                          SizedBox(width: 10),
                          Text('Medications'),
                        ],
                      ),
                      padding: 10,
                      borderRadius: 10,
                    ),
                    SizedBox(width: 15),
                    RoundedContainer(
                      padding: 10,
                      child: Text(
                        'June 17 ,2024',
                        style: TextStyle(fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ursofalk 300', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 5),
                    Text(
                      '2 Pills. 02:00 PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.greyColor.withOpacity(0.8),
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Routine Medicine', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 5),
                    Text(
                      'No observations or notes',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.greyColor.withOpacity(0.8),
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Indever 20', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 5),
                    Text(
                      '1 Pill. 02:20 PM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.greyColor.withOpacity(0.8),
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Emergency', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 5),
                    Text(
                      'Patient observed to be having seizures. Indever given to reduce blood pressure',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.greyColor.withOpacity(0.8),
                        fontFamily: 'Poppins-Regular',
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ],
    );
  }
}
