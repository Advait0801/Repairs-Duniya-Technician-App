import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:technician_app/notification.dart';
import 'package:technician_app/presentation/profile_screen/profile_screen.dart';
import 'package:technician_app/presentation/technician_home_screen/widgets/new_bookings_widget.dart';
import 'package:technician_app/presentation/technician_home_screen/widgets/userprofilesection_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/widgets/app_bar/appbar_title.dart';
import 'package:technician_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';
import 'package:technician_app/widgets/half_page.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  User? _user;
  LatLng? _currentPosition;
  bool showHalfPage = false;
  List<NewBookingWidget> newBookings = [];
  List<UserprofilesectionItemWidget> recentBookings = [];

  @override
  void initState() {
    super.initState();
    PushNotificationSystem notificationSystem = PushNotificationSystem();
    notificationSystem.whenNotificationReceived(context);
    setState(() {
      showHalfPage = true;
    });
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        getEntries();
      });
    });
    getCurrentLocation();
    setupDeviceToken();
    initializePermission();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    bool documentExists = await _firestore
        .collection('technicians')
        .doc(_user!.uid)
        .collection('location')
        .doc('currentLocation')
        .get()
        .then((DocumentSnapshot document) => document.exists);

    if (documentExists == true) {
      try {
        await _firestore
            .collection('technicians')
            .doc(_user!.uid)
            .collection('location')
            .doc('currentLocation')
            .update({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude
        });
      } catch (e) {
        log(e.toString());
      }
    } else {
      try {
        await _firestore
            .collection('technicians')
            .doc(_user!.uid)
            .collection('location')
            .doc('currentLocation')
            .set({
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude
        }, SetOptions(merge: true));
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<void> initializePermission() async {
    bool isDenied = await Permission.notification.isDenied;
    if (isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> setupDeviceToken() async {
    String? token = await _messaging.getToken();
    _uploadToken(token!);
    _messaging.onTokenRefresh.listen(_uploadToken);
  }

  Future<void> _uploadToken(String token) async {
    try {
      await _firestore
          .collection('technicians')
          .doc(_user!.uid)
          .set({'token': token}, SetOptions(merge: true));
    } catch (e) {
      log(e.toString());
    }
  }

  void _showHalfPage(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: HalfPage(
            onClose: () {
              // Callback function to be invoked when the half page is closed
              _hideHalfPage(context);
            },
          ),
        );
      },
    ));
  }

  void _hideHalfPage(BuildContext context) {
    // Use Navigator.pop(context) to remove the topmost route
    Navigator.pop(context);
    // Update the state or perform other actions as needed
    setState(() {
      showHalfPage = false;
    });
  }

  Future<void> getEntries() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('technicians')
          .doc(_user!.uid)
          .collection('serviceList')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          String docId = documentSnapshot.id;
          if (documentSnapshot['status'] == 'p') {
            Timestamp timeStamp = documentSnapshot['date'];
            DateTime datetime = timeStamp.toDate();
            String date = '${datetime.day}/${datetime.month}/${datetime.year}';
            newBookings.add(
              NewBookingWidget(
                //customerId: customerTokenId!,
                docName: docId,
                timing: documentSnapshot['timeIndex'],
                phoneNumber: documentSnapshot['customerPhone'],
                address: documentSnapshot['customerAddress'],
                day: date,
              ),
            );
          } else if (documentSnapshot['status'] == 'c') {
            Timestamp timestamp = documentSnapshot['date'];
            DateTime dateTime = timestamp.toDate();
            String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
            recentBookings.add(
              UserprofilesectionItemWidget(
                timing: documentSnapshot['timeIndex'],
                phone: documentSnapshot['customerPhone'],
                address: documentSnapshot['customerAddress'],
                date: date,
              ),
            );
          }
        }
      }
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onError,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildFrame(context),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 17.h,
                      vertical: 28.v,
                    ),
                    child: Column(
                      children: [
                        _buildSubscribeRow(context),
                        SizedBox(height: 25.v),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 4.h),
                            child: Text(
                              "New Bookings",
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                        ),
                        SizedBox(height: 13.v),
                        _buildBookingRow(context),
                        SizedBox(height: 40.v),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.h),
                            child: Text(
                              "Recent Bookings",
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                        ),
                        SizedBox(height: 26.v),
                        _buildUserProfileList(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingRow(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: newBookings.length,
      itemBuilder: (context, index, realIndex) {
        return NewBookingWidget(
          //customerId: newBookings[index].customerId,
          docName: newBookings[index].docName,
          address: newBookings[index].address,
          timing: newBookings[index].timing,
          day: newBookings[index].day,
          phoneNumber: newBookings[index].phoneNumber,
        );
      },
      options: CarouselOptions(
        viewportFraction: 1,
        aspectRatio: 16 / 11,
        autoPlay: false,
        enableInfiniteScroll: false,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.v),
      decoration: AppDecoration.gradientPrimaryToGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.v, vertical: 16.h),
                child: CustomImageView(
                  onTap: () {
                    showHalfPage == true
                        ? _hideHalfPage(context)
                        : _showHalfPage(context);
                  },
                  imagePath: ImageConstant.imgMenu,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
              AppbarTitle(text: 'Home'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()));
                },
                child: AppbarTrailingImage(
                  imagePath: ImageConstant.imgGroup,
                  margin: EdgeInsets.only(
                    left: 38.h,
                    top: 3.v,
                  ),
                ),
              ),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgGroup5139931,
                margin: EdgeInsets.only(
                  left: 24.h,
                  right: 46.h,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSubscribeRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 7.h),
      decoration: AppDecoration.gradientOrangeAToOnError
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 17.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgEllipse13,
                  height: 45.adaptSize,
                  width: 45.adaptSize,
                  radius: BorderRadius.circular(22.h),
                ),
                SizedBox(height: 10.v),
                SizedBox(
                  width: 166.h,
                  child: Text(
                    "To get more works subscribe to our gold plan",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: appTheme.gray80001,
                      fontSize: 12.fSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
                CustomElevatedButton(
                  height: 36.v,
                  width: 157.h,
                  text: "Subscribe",
                  buttonStyle: CustomButtonStyles.outlinePrimaryTL13,
                )
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgImage90,
            height: 163.adaptSize,
            width: 163.adaptSize,
            margin: EdgeInsets.only(top: 3.v),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildUserProfileList(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 9.h),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (
            context,
            index,
          ) {
            return SizedBox(
              height: 16.v,
            );
          },
          itemCount: recentBookings.length,
          itemBuilder: (context, index) {
            return UserprofilesectionItemWidget(
              timing: recentBookings[index].timing,
              phone: recentBookings[index].phone,
              address: recentBookings[index].address,
              date: recentBookings[index].date,
            );
          },
        ),
      ),
    );
  }
}
