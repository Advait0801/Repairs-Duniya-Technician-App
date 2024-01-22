import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/my_bookings/my_bookings_screen.dart';
import 'package:technician_app/presentation/technician_home_screen/technician_home_screen.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewBookingWidget extends StatefulWidget {
  final String phoneNumber;
  final String address;
  final String day;
  final String docName;
  final String timing;
  final String service;

  const NewBookingWidget(
      {super.key,
      required this.service,
      required this.docName,
      required this.address,
      required this.day,
      required this.timing,
      required this.phoneNumber});

  @override
  State<NewBookingWidget> createState() => _NewBookingWidgetState();
}

class _NewBookingWidgetState extends State<NewBookingWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  static const time = Duration(minutes: 3);
  Duration duration = const Duration();
  Timer? timer;
  Duration currentTime = time;
  String customerId = '';
  String customerTokenId = '';

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
    startTimer();
    reset();
  }

  void reset() {
    setState(() {
      duration = currentTime;
    });
  }

  void countDown() {
    setState(() {
      final seconds = duration.inSeconds - 1;
      if (seconds < 0) {
        timer?.cancel();
        setStatus('r');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TechnicianHomeScreen()));
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => countDown());
  }

  Future<void> setStatus(String status) async {
    try {
      await _firestore
          .collection('technicians')
          .doc(_user!.uid)
          .collection('serviceList')
          .doc(widget.docName)
          .update({'status': status});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final String date = widget.day.toString();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 9.h),
      padding: EdgeInsets.all(20.h),
      decoration: AppDecoration.gradientOnErrorToBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgGroupOnprimary,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 13.h,
                            top: 2.v,
                            bottom: 4.v,
                          ),
                          child: Text(
                            widget.phoneNumber,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage86,
                          height: 22.v,
                          width: 24.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 13.h,
                            top: 2.v,
                            bottom: 3.v,
                          ),
                          child: Text(
                            widget.service,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage87,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 13.h,
                            top: 3.v,
                            bottom: 3.v,
                          ),
                          child: Text(
                            date,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage88,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 13.h,
                            top: 4.v,
                            bottom: 2.v,
                          ),
                          child: Text(
                            widget.timing,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgVector,
                          height: 22.v,
                          width: 21.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12.h,
                            top: 4.v,
                          ),
                          child: Text(
                            widget.address,
                            style: CustomTextStyles.bodySmallBluegray700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.v),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 19.v,
                  ),
                  decoration: AppDecoration.fillRed.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder57,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 64.h,
                        child: Text(
                          "Accept Booking within",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.bodySmallInterBluegray700
                              .copyWith(
                            height: 1.70,
                          ),
                        ),
                      ),
                      SizedBox(height: 3.v),
                      _buildTimer(context),
                      SizedBox(height: 11.v),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Get Bonus of 100/-",
                          style: CustomTextStyles.bodySmallInterBluegray700,
                        ),
                      ),
                      SizedBox(height: 3.v),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.v),
          Padding(
            padding: EdgeInsets.only(right: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () {
                      sendingNotification();
                      setStatus('p');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyBookingsScreen(id: 'p')));
                    },
                    height: 49.v,
                    text: "Accept",
                    margin: EdgeInsets.only(right: 6.h),
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles
                        .gradientLightGreenAToOnPrimaryContainerDecoration,
                    buttonTextStyle: theme.textTheme.labelLarge!,
                  ),
                ),
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () {
                      setStatus('r');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyBookingsScreen(id: 'r')));
                    },
                    height: 49.v,
                    text: "Reject",
                    margin: EdgeInsets.only(left: 6.h),
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles.gradientRedAToRedDecoration,
                    buttonTextStyle: theme.textTheme.labelLarge!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendingNotification() async {
    await _firestore
        .collection('technicians')
        .doc(_user!.uid)
        .collection('serviceList')
        .doc(widget.docName)
        .get()
        .then((snapshot) {
      setState(() {
        customerId = snapshot.data()!['customerId'];
        customerTokenId = snapshot.data()!['customerTokenId'];
        log(customerTokenId);
      });
    });

    notificationFormat() async {
      log("Building notification format...");

      Map<String, String> headerNotification = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAA0PM0nhk:APA91bGFFhcYO051DiIDsKkcBX5cuOMWwAD_OhGxojHbiBdSogf5IJ7M0sptK8PVl7ifwsbLAziNw9F0KTRfPTTm9ePqf0oFpbmLaQErM4HK9Inz7P7_3JWjmzX-1m8DFtlRTeeJe3KL",
      };

      Map bodyNotification = {
        "body":
            "Your service request has been successfully accepted by ${_user!.phoneNumber}",
        "title": "Technician Assigned",
      };

      Map dataMap = {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "phonenumber": _user!.phoneNumber,
        "user": _user!.uid,
      };

      Map notificationFormat = {
        "notification": bodyNotification,
        "data": dataMap,
        "priority": "high",
        "to": customerTokenId,
      };

      log("Sending notification to customer $customerId...");
      try {
        final response = await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: headerNotification,
          body: jsonEncode(notificationFormat),
        );

        if (response.statusCode == 200) {
          log("Notification sent successfully to technician $customerId.");
          log(customerTokenId);
        } else {
          log("Failed to send notification to technician ${_user!.uid} Status code: ${response.statusCode}");
        }
      } catch (e) {
        log("Error while sending notification to technician ${_user!.uid}: $e");
      }
    }

    notificationFormat();
  }

  _buildTimer(BuildContext context) {
    return buildTime();
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$minutes:$seconds',
            style: theme.textTheme.titleLarge,
          ),
          TextSpan(
            text: "min",
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}
