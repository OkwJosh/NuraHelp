import 'package:flutter/material.dart';
import '../appointment_card.dart';

class CanceledAppointmentTabContent extends StatelessWidget {
  const CanceledAppointmentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            AppointmentCard(status: 'canceled',isVirtual: false,showStatus: true),
            SizedBox(height: 10),
            AppointmentCard(status: 'canceled',isVirtual: false,showStatus: true),
            SizedBox(height: 10),
            AppointmentCard(status: 'canceled',isVirtual: false,showStatus: true),
          ],
        ),
      ],
    );
  }
}


