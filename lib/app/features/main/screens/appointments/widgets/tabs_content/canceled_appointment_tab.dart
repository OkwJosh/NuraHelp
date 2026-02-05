import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import '../../../../../../common/appointment_card/appointment_card.dart';

class CanceledAppointmentTabContent extends StatelessWidget {
  const CanceledAppointmentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final patientController = Get.find<PatientController>();

    return Obx(() {
      final response = patientController.patient.value;

      // Filter for canceled appointments (check status from backend)
      final canceledAppointments =
          response?.appointments
              .where((apt) => apt.status == 'Canceled')
              .toList() ??
          [];

      if (canceledAppointments.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Iconify(
                Mdi.clipboard_off_outline,
                color: Colors.grey[300],
                size: 80,
              ),
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

      return SizedBox(
        height: 500,
        child: ListView.separated(
          itemBuilder: (context, index) => AppointmentCard(
            patientController: patientController,
            appointment: canceledAppointments[index],
            isVirtual: false,
            showStatus: true,
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: canceledAppointments.length,
        ),
      );
    });
  }
}
