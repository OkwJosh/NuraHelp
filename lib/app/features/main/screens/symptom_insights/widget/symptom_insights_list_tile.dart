import 'package:flutter/material.dart';
import 'package:nurahelp/app/utilities/constants/svg_icons.dart';
import '../../../../../utilities/constants/colors.dart';
import '../../../../../utilities/constants/icons.dart';

class SymptomInsightListTile extends StatelessWidget {
  const SymptomInsightListTile({
    super.key,
    this.showBottomBorder = true,
  });

  final bool showBottomBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:15,bottom: 15),
      decoration:BoxDecoration(
          border: showBottomBorder?Border(
            bottom: BorderSide(color: AppColors.greyColor.withOpacity(0.6),width: 0.5),
          ):null
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.greenAccent.withOpacity(0.3),
              ),
              padding: EdgeInsets.all(5),
              child: SvgIcon(AppIcons.broadcast,size: 25,)
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pain, fatigue and GIT symptoms have increased by 2% over the last 1 week',
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Poppins-Light",
                  fontSize: 13,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
