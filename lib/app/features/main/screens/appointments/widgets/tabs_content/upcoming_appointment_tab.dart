import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/features/main/controllers/patient/patient_controller.dart';
import 'package:nurahelp/app/utilities/constants/icons.dart';
import '../../../../../../common/appointment_card/appointment_card.dart';

class UpcomingAppointmentTabContent extends StatelessWidget {
  const UpcomingAppointmentTabContent({
    super.key,
    required this.patientController,
  });

  final PatientController patientController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = patientController.patient.value;
      final hasAppointments = response?.appointments.isNotEmpty ?? false;

      if (!hasAppointments) {
        return _buildNoAppointmentsView(context);
      }

      // Filter for non-canceled appointments (check status from backend)
      final upcomingAppointments = response!.appointments
          .where((apt) => apt.status != 'Canceled')
          .toList();

      if (upcomingAppointments.isEmpty) {
        return _buildNoAppointmentsView(context);
      }

      return SizedBox(
        height: 500,
        child: ListView.separated(
          itemBuilder: (context, index) => AppointmentCard(
            patientController: patientController,
            appointment: upcomingAppointments[index],
            isVirtual: false,
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: upcomingAppointments.length,
        ),
      );
    });
  }

  Widget _buildNoAppointmentsView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.navClipboard, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            'No Upcoming Appointments',
            style: TextStyle(fontSize: 18, fontFamily: 'Poppins-SemiBold'),
          ),
          const SizedBox(height: 10),
          Text(
            'You don\'t have any scheduled appointments',
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
