import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 645029584,
      appSign:
          '349504939c5810841a10596660c089d443c47262051760251344d4aa0fe3e62d',
      userName: 'Joshua',
      callID: '123776',
      userID: 'joshieishim',
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}

// Scaffold(
// body: Stack(
// children: [
// Container(color: AppColors.secondaryColor.withOpacity(0.4)),
// Positioned(
// top: 60,
// left: 0,
// right: 0,
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 15),
// child: Row(
// spacing: MediaQuery.of(context).size.width / 5,
// children: [
// IconButton(
// onPressed: () => Get.back(),
// icon: Icon(
// Icons.arrow_back_ios_new_sharp,
// color: Colors.white,
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// 'Dr Helena Fox',
// style: TextStyle(
// color: Colors.white,
// fontFamily: 'Poppins-Light',
// ),
// ),
// Text(
// '03:25',
// style: TextStyle(
// color: Colors.white,
// fontFamily: 'Poppins-ExtraLight',
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// Positioned(
// bottom: 110,
// right: 20,
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(10),
// color: Colors.white,
// ),
// height: 200,
// width: 120,
// ),
// ),
// Positioned(
// bottom: 30,
// left: MediaQuery.of(context).size.width / 20,
// right: MediaQuery.of(context).size.width / 20,
// child: Row(
// spacing: 5,
// children: [
// OutlinedButton(
// onPressed: () {},
// style: OutlinedButton.styleFrom(
// backgroundColor: AppColors.secondaryColor,
// shape: CircleBorder(),
// side: BorderSide.none,
// padding: EdgeInsets.zero,
// ),
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// child: SvgIcon(AppIcons.micOff),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.white,
// shape: CircleBorder(),
// side: BorderSide.none,
// padding: EdgeInsets.zero,
// ),
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// child: SvgIcon(AppIcons.camera, color: AppColors.black),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.white,
// shape: CircleBorder(),
// side: BorderSide.none,
// padding: EdgeInsets.zero,
// ),
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// child: SvgIcon(AppIcons.flip, color: AppColors.black),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.white,
// shape: CircleBorder(),
// side: BorderSide.none,
// padding: EdgeInsets.zero,
// ),
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// child: SvgIcon(AppIcons.messages, color: AppColors.black),
// ),
// ),
// OutlinedButton(
// onPressed: () {},
// style: OutlinedButton.styleFrom(
// backgroundColor: Colors.red,
// shape: CircleBorder(),
// side: BorderSide.none,
// padding: EdgeInsets.zero,
// ),
// child: Padding(
// padding: const EdgeInsets.all(15.0),
// child: SvgIcon(AppIcons.callOff),
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// );
