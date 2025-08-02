import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(decoration: InputDecoration(hintText: 'John Doe')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(hintText: 'example@gmail.com')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(hintText: '09123639400')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(hintText: '20-08-2002')),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Create password',
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
