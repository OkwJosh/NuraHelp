import 'package:flutter/material.dart';
import 'package:nurahelp/app/features/main/patients/widgets/patient_info_tile.dart';
import '../../../common/appbar/appbar_with_bell.dart';
import '../../../common/custom_switch/custom_switch.dart';
import '../../../utilities/constants/colors.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: AppBarWithBell()),
        Positioned.fill(
            top: 130,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                          height: 40,
                          width: 290,
                          child: CustomSwitch(numberOfOptions: 3,firstOptionText: 'Overview',secondOptionText: 'In-patients',thirdOptionText: 'Out-patient',)),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: (){}, icon: Icon(Icons.sort),
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(
                              color: AppColors.greyColor,
                              width: 0.5
                            )
                          )
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          backgroundColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'New patient',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Poppins-Light",
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 0,
                        bottom: 80,
                        top: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 10.0,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Patient List',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins-Regular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            elevation: 1,
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.bluishWhiteColor,

                                    ),
                                    margin: EdgeInsets.zero,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ADMITTED',
                                          style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontSize: 12
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(-100, 0),
                                          child: Text(
                                            'PATIENT',
                                            style: TextStyle(
                                              fontFamily: "Poppins-Regular",
                                              fontSize: 12
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                  PatientInfoTile(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ),
        ),
        ],
      )
    );
  }
}
