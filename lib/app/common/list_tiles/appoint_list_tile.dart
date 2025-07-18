import 'package:flutter/material.dart';

class AppointmentListTile extends StatelessWidget {
  const AppointmentListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          left: 10.0, top: 15, bottom: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Expanded(
                  child: Text(
                    '09:00 AM - 10:00 AM',
                    style: const TextStyle(
                      fontFamily: 'Poppins-Light',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(radius: 20),
              SizedBox(width: 10),
              Text(
                'Jesse Lee',
                style: const TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
