import 'package:flutter/material.dart';
import '../review.dart';

class ReviewsTabContent extends StatelessWidget {
  const ReviewsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Column(
              spacing: 15,
              children: [
                Reviews(
                  patientName: 'Sarah P.',
                  date: 'May 11, 2024',
                  reviewBody:
                      'Dr. Montgomery’s expertise in cardiology is outstanding. She made me feel comfortable and explained everything in detail. Her approach to heart health is proactive and compassionate. I’m grateful for her care and highly recommend her.',
                ),
                Reviews(
                  patientName: 'John D.',
                  date: 'Sept 28, 2024',
                  reviewBody:
                      'Dr. Charlotte is an experienced cardiologist, she specializes in preventive cardiology, heart failure management, and advanced cardiac imaging. With a patient-focused approach, she delivers personalized high-quality care.',
                ),
                Reviews(
                  patientName: 'John D.',
                  date: 'Sept 28, 2024',
                  reviewBody:
                      'Dr. Charlotte is an experienced cardiologist, she specializes in preventive cardiology, heart failure management, and advanced cardiac imaging. With a patient-focused approach, she delivers personalized high-quality care.',
                ),
                Reviews(
                  patientName: 'John D.',
                  date: 'Sept 28, 2024',
                  reviewBody:
                      'Dr. Charlotte is an experienced cardiologist, she specializes in preventive cardiology, heart failure management, and advanced cardiac imaging. With a patient-focused approach, she delivers personalized high-quality care.',
                ),
                Reviews(
                  patientName: 'Sarah P.',
                  date: 'May 11, 2024',
                  reviewBody:
                      'Dr. Montgomery’s expertise in cardiology is outstanding. She made me feel comfortable and explained everything in detail. Her approach to heart health is proactive and compassionate. I’m grateful for her care and highly recommend her.',
                ),
                Reviews(
                  patientName: 'John D.',
                  date: 'Sept 28, 2024',
                  reviewBody:
                      'Dr. Charlotte is an experienced cardiologist, she specializes in preventive cardiology, heart failure management, and advanced cardiac imaging. With a patient-focused approach, she delivers personalized high-quality care.',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
