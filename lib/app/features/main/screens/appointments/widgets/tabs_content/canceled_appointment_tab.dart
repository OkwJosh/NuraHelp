import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';


class CanceledAppointmentTabContent extends StatelessWidget {
  const CanceledAppointmentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(Mdi.clipboard_off_outline, color: Colors.grey[300], size: 80),
          const SizedBox(height: 20),
          const Text(
            'No Canceled Appointments',
            style: TextStyle(fontSize: 18, fontFamily: 'Poppins-SemiBold'),
          ),
          const SizedBox(height: 10),
          Text(
            'You don\'t have any canceled appointments',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Regular',
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        ],
      ),
    );
  }
}
