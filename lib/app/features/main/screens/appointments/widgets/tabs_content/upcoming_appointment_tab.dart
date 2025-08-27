import 'package:flutter/material.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import '../../../../../../common/appointment_card/appointment_card.dart';

class UpcomingAppointmentTabContent extends StatelessWidget {
  const UpcomingAppointmentTabContent({
    super.key,
    required this.patientController,
  });

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    final clinicalResponse = patientController.patient.value.clinicalResponse;
    return SizedBox(
      height: 500,
      child: ListView.separated(
        itemBuilder: (context, index) =>
            AppointmentCard(patientController: patientController, isVirtual:false),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: clinicalResponse!.appointments.length,
      ),
    );
  }
}
