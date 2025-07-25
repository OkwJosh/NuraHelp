import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/uil.dart';

import '../../../../../utilities/constants/colors.dart';

class TestResultCard extends StatelessWidget {
  const TestResultCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0.1,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 20,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Complete Blood Count (CBC)'),
              Text('02 Jan,2024'),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.visibility, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'View report',
                              style: TextStyle(color: Colors.white,fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.secondaryColor
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.download, color: AppColors.secondaryColor),
                            SizedBox(width: 5),
                            Text(
                              'Download',
                              style: TextStyle(color: AppColors.secondaryColor,fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Iconify(Uil.ellipsis_v),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
