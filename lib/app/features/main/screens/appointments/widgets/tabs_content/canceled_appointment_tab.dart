import 'package:flutter/material.dart';
import '../../../../../../common/appointment_card/appointment_card.dart';


class CanceledAppointmentTabContent extends StatelessWidget {
  const CanceledAppointmentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 250),
        Text('No Canceled Appointment'),
        SizedBox(height: 250),
      ],
    );
  }
}


