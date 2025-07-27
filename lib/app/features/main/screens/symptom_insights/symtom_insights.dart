import 'package:flutter/material.dart';
import 'package:nurahelp/app/common/custom_switch/custom_switch.dart';
import 'package:nurahelp/app/features/main/screens/symptom_insights/widget/symptom_dropdown.dart';
import 'package:nurahelp/app/features/main/screens/symptom_insights/widget/symptom_insights_list_tile.dart';
import 'package:nurahelp/app/features/main/screens/symptom_insights/widget/symptoms_trend_chart.dart';
import 'package:nurahelp/app/utilities/constants/colors.dart';
import '../../../../common/appbar/appbar_with_bell.dart';



class SymptomInsightsScreen extends StatelessWidget {
  const SymptomInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
          Positioned.fill(
            top: 100,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 0.1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 15,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Log Today\'s Symptoms',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 15),
                              SymptomDropdown(symptomName: 'Pain'),
                              SizedBox(height: 10),
                              SymptomDropdown(symptomName: 'Fatigue'),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                spacing: 10,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppColors.secondaryColor,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                    ),
                                    child: Row(
                                      spacing: 3,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: AppColors.secondaryColor,
                                        ),
                                        Text(
                                          'Add',
                                          style: TextStyle(
                                            color: AppColors.secondaryColor,
                                              fontFamily: 'Poppins-Light'
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15)
                                    ),
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white,fontSize: 14,fontFamily: 'Poppins-Light'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Symptom Trends",
                                      style: TextStyle(
                                        fontFamily: "Poppins-Regular",
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    width: 90,
                                    child: CustomSwitch(
                                      firstOptionText: '1W',
                                      secondOptionText: '1M',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SymptomTrendChart(),
                            SizedBox(height: 5),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor: Colors.purpleAccent,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Key title goes here',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins-ExtraLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor: Colors.orange,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Key title goes here',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins-ExtraLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor:
                                              AppColors.deepSecondaryColor,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Key title goes here',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins-ExtraLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 7,
                                          backgroundColor: Colors.greenAccent,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Key title goes here',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins-ExtraLight',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          Text(
                            'Set alerts for worsening patients',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins-Light',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Material(
                      elevation: 1,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SymptomInsightListTile(),
                            SymptomInsightListTile(),
                            SymptomInsightListTile(),
                            SymptomInsightListTile(showBottomBorder: false),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
