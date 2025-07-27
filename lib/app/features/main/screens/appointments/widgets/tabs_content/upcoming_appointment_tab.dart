import 'package:flutter/material.dart';
import '../appointment_card.dart';


class UpcomingAppointmentTabContent extends StatelessWidget {
  const UpcomingAppointmentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            AppointmentCard(),
            SizedBox(height: 10),
            AppointmentCard(isVirtual: false),
            SizedBox(height: 10),
            AppointmentCard(isVirtual: false),
          ],
        ),
      ],
    );
  }
}
