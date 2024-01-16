import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/technician_home_screen/technician_home_screen.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  bool flag1 = false;
  bool flag2 = false;
  bool flag3 = false;
  bool flag4 = false;
  bool flag5 = false;
  bool flag = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<String> services = [];
  List<String> extraServices = [
    'Geyser',
    'Air Cooler',
    'MicroWave/Oven'
        'Painter',
    'CCTV'
  ];

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  bool getValue() {
    if (flag1 || flag2 || flag3 || flag4 || flag5) {
      return true;
    }
    return false;
  }

  Future<void> uploadServices() async {
    try {
      if (flag1) services.add('AC');
      if (flag2) services.add('Fridge');
      if (flag3) services.add('Washing Machine');
      if (flag4) services.add('Plumber');
      if (flag5) services.add('Electrician');

      await _firestore.collection('technicians').doc(_user!.uid).set(
        {'services': FieldValue.arrayUnion(services)},
        SetOptions(merge: true),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TechnicianHomeScreen()),
          (route) => false);
    } catch (e) {
      log("Failed to upload services: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.5, 0),
              end: const Alignment(0.5, 1),
              colors: [
                theme.colorScheme.onError,
                appTheme.gray50,
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 23.h,
              vertical: 29.v,
            ),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgImage91,
                  height: 154.v,
                  width: 181.h,
                ),
                SizedBox(height: 24.v),
                Text(
                  "Service Selection",
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(height: 12.v),
                Text(
                  "Select the services you render below",
                  style: theme.textTheme.bodyLarge,
                ),
                SizedBox(height: 32.v),
                _buildServiceSelectionRow1(context),
                SizedBox(height: 12.v),
                _buildServiceSelectionRow2(context),
                SizedBox(height: 30.v),
                CustomElevatedButton(
                  buttonStyle: flag == true
                      ? const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black))
                      : const ButtonStyle(),
                  text: "Confirm",
                  onPressed: () {
                    uploadServices();
                  },
                ),
                SizedBox(height: 32.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildServiceSelectionRow1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: 8.h,
                bottom: 16.v,
              ),
              child: Column(
                children: [
                  Container(
                    height: 115.adaptSize,
                    width: 115.adaptSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.h,
                      vertical: 37.v,
                    ),
                    decoration: AppDecoration.outlineBlueGrayE.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                      color: flag1 == true
                          ? const Color(0xFFCBCBCB)
                          : Colors.white,
                    ),
                    child: CustomImageView(
                      onTap: () {
                        setState(() {
                          flag1 = !flag1;
                          flag = getValue();
                        });
                      },
                      imagePath: ImageConstant.imgImage38,
                      height: 37.v,
                      width: 106.h,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    "AC Repair",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8.h,
                right: 8.h,
                bottom: 16.v,
              ),
              child: Column(
                children: [
                  Container(
                    height: 115.adaptSize,
                    width: 115.adaptSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.h,
                      vertical: 7.v,
                    ),
                    decoration: AppDecoration.outlineBlueGrayE.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                      color: flag2 == true
                          ? const Color(0xFFCBCBCB)
                          : Colors.white,
                    ),
                    child: CustomImageView(
                      onTap: () {
                        setState(() {
                          flag2 = !flag2;
                          flag = getValue();
                        });
                      },
                      imagePath: ImageConstant.imgImage34,
                      height: 98.v,
                      width: 65.h,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    "Fridge Repair",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Column(
                children: [
                  Container(
                    height: 115.adaptSize,
                    width: 115.adaptSize,
                    padding: EdgeInsets.symmetric(horizontal: 14.h),
                    decoration: AppDecoration.outlineBlueGrayE.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                      color: flag3 == true
                          ? const Color(0xFFCBCBCB)
                          : Colors.white,
                    ),
                    child: CustomImageView(
                      onTap: () {
                        setState(() {
                          flag3 = !flag3;
                          flag = getValue();
                        });
                      },
                      imagePath: ImageConstant.imgImage31,
                      height: 106.v,
                      width: 86.h,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                  SizedBox(
                    width: 99.h,
                    child: Text(
                      "Washing Machine Repair",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelectionRow2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: 8.h,
                bottom: 16.v,
              ),
              child: Column(
                children: [
                  Container(
                    height: 115.adaptSize,
                    width: 115.adaptSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.h,
                      vertical: 37.v,
                    ),
                    decoration: AppDecoration.outlineBlueGrayE.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                      color: flag4 == true
                          ? const Color(0xFFCBCBCB)
                          : Colors.white,
                    ),
                    child: CustomImageView(
                      onTap: () {
                        setState(() {
                          flag4 = !flag4;
                          flag = getValue();
                        });
                      },
                      imagePath: ImageConstant.imgImage83,
                      height: 85.v,
                      width: 116.h,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    "Plumber",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8.h,
                right: 8.h,
                bottom: 16.v,
              ),
              child: Column(
                children: [
                  Container(
                    height: 115.adaptSize,
                    width: 115.adaptSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.h,
                      vertical: 7.v,
                    ),
                    decoration: AppDecoration.outlineBlueGrayE.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                      color: flag5 == true
                          ? const Color(0xFFCBCBCB)
                          : Colors.white,
                    ),
                    child: CustomImageView(
                      onTap: () {
                        setState(() {
                          flag5 = !flag5;
                          flag = getValue();
                        });
                      },
                      imagePath: ImageConstant.imgImage78,
                      height: 104.v,
                      width: 94.h,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    "Electrician",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Column(
                children: [
                  Container(
                    height: 115.adaptSize,
                    width: 115.adaptSize,
                    padding: EdgeInsets.symmetric(horizontal: 14.h),
                    decoration: AppDecoration.outlineBlueGrayE.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgFrame5140235,
                      height: 9.v,
                      width: 55.h,
                      alignment: Alignment.center,
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    "More",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
