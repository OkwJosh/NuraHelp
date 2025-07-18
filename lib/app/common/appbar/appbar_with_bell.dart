import 'package:flutter/material.dart';

class AppBarWithBell extends StatelessWidget {
  const AppBarWithBell({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: Container(
        height: 95,
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0,right: 20.0,top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("LOGO",style: TextStyle(fontSize: 25,fontFamily: "Poppins-Bold")),
              Row(
                children: [
                  Icon(Icons.notifications_none_outlined,color: Colors.black,size: 25),
                  SizedBox(width: 10),
                  Icon(Icons.menu,color: Colors.black,size: 25),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
