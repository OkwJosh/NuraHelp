import 'package:flutter/material.dart';
import '../../../../../utilities/constants/colors.dart';

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
                borderRadius: BorderRadius.circular(10),
                color: Colors.greenAccent,
              ),
              padding: EdgeInsets.all(5),
              child: Icon(Icons.cast, size: 25),
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
