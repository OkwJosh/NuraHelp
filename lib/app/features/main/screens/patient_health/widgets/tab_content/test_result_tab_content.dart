import 'package:flutter/material.dart';
import '../../../../../../common/button/custom_arrow_button.dart';
import '../../../../../../common/rounded_containers/rounded_container.dart';
import '../test_result_card.dart';

class TestResultTabContent extends StatelessWidget {
  const TestResultTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        SizedBox(height: 15),
        TestResultCard(),
        SizedBox(height: 15),
        TestResultCard(),
        SizedBox(height: 15),
        TestResultCard(),
      ],
    );
  }
}

