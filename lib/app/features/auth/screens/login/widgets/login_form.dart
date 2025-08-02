import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Email Address'),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: IconButton(icon:Icon(Icons.visibility_off_outlined), onPressed: () {  },),
          ),
        ),
      ],
    );
  }
}

