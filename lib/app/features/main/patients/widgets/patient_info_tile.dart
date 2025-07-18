import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../utilities/constants/colors.dart';
import '../patient_info.dart';

class PatientInfoTile extends StatelessWidget {
  const PatientInfoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => Get.to(() => PatientInfo()),
        child: Container(
          padding: const EdgeInsets.only(left: 15.0, top: 15, bottom: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '27 Dec, 2024',
                        style: const TextStyle(
                          fontFamily: 'Poppins-Light',
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis, // ✅ Truncate if too long
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 20),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vincent Achu',
                            style: const TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis, // ✅ Truncate if too long
                          ),
                          Text(
                            'NH-012345',
                            style: TextStyle(
                              fontFamily: 'Poppins-Light',
                              color: AppColors.greyColor,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.info),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
