import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
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
              Text('Complete Blood Count (CBC)',style: TextStyle(fontFamily: 'Poppins-Medium',fontSize: 16)),
              Text('02 Jan,2024',style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14,color: AppColors.black300)),
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
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgIcon(AppIcons.eye,color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'View report',
                              style: TextStyle(color: Colors.white,fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppColors.secondaryColor
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:10,
                            vertical: 10,
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgIcon(AppIcons.download,color: AppColors.secondaryColor),
                            SizedBox(width: 5),
                            Text(
                              'Download',
                              style: TextStyle(color: AppColors.secondaryColor,fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  IconButton(
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: (){}, icon: SvgIcon(AppIcons.ellipsis))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
