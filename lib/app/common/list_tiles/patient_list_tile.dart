import 'package:flutter/material.dart';

import '../../utilities/constants/colors.dart';

class PatientListTile extends StatelessWidget {
  const PatientListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.greyColor, width: 0.2),
        ),
      ),
      padding: const EdgeInsets.only(left: 15.0, top: 15, bottom: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const CircleAvatar(radius: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
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
                ),
              ],
            ),
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '(234) 9124605849',
                style: const TextStyle(
                  fontFamily: 'Poppins-Medium',
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'example@gmail.com',
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
    );
  }
}
