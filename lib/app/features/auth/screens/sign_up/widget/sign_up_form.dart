import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(decoration: InputDecoration(hintText: 'Full Name')),
        SizedBox(height: 15),
        TextField(decoration: InputDecoration(hintText: 'Email Address')),
        SizedBox(height: 15),
        TextField(decoration: InputDecoration(hintText: 'Phone number')),
        SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(hintText: 'Clinic/Hospital name'),
        ),
        SizedBox(height: 15),
        TextField(decoration: InputDecoration(hintText: 'Medical License ID')),
        SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility_off_outlined),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
