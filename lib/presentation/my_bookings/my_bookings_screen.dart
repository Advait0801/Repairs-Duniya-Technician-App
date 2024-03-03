// ignore_for_file: unused_field, must_be_immutable
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/technician_home_screen/notifications_display.dart';
import 'package:technician_app/presentation/technician_home_screen/profile_screen.dart';
import 'package:technician_app/presentation/technician_home_screen/technician_home_screen.dart';
import 'package:technician_app/widgets/app_bar/appbar_title.dart';
import 'package:technician_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:technician_app/widgets/completed_widget.dart';
import 'package:technician_app/widgets/decline_widget.dart';
import 'package:technician_app/widgets/half_page.dart';
import 'package:technician_app/widgets/pending_widget.dart';

class MyBookingsScreen extends StatefulWidget {
  MyBookingsScreen({super.key, required this.id});
  String id;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String screenId = '';
  bool showHalfPage = true;
  List<CompletedWidget> completed = [];
  List<PendingWidget> pending = [];
  List<DeclineWidget> rejected = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      screenId = widget.id;
      showHalfPage = false;
    });
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
        getEntries();
      });
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
          if (documentSnapshot['status'] == 'p' ||
              documentSnapshot['status'] == 's') {
            Timestamp timeStamp = documentSnapshot['date'];
            DateTime datetime = timeStamp.toDate();
            String date = '${datetime.day}/${datetime.month}/${datetime.year}';
            pending.add(
              PendingWidget(
                serviceName: documentSnapshot['serviceName'],
                id: documentSnapshot['status'],
                docName: docId,
                timing: documentSnapshot['urgentBooking'] == true
                    ? 'Urgent Booking'
                    : documentSnapshot['timeIndex'],
                phone: documentSnapshot['customerPhone'],
                address: documentSnapshot['customerAddress'],
                location: documentSnapshot['customerLocation'],
                date: date,
              ),
            );
          } else if (documentSnapshot['status'] == 'c') {
            Timestamp timestamp = documentSnapshot['date'];
            DateTime dateTime = timestamp.toDate();
            String time =
                '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
            String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
            completed.add(
              CompletedWidget(
                time: time,
                timing: documentSnapshot['urgentBooking'] == true
                    ? 'Urgent Booking'
                    : documentSnapshot['timeIndex'],
                serviceName: documentSnapshot['serviceName'],
                phone: documentSnapshot['customerPhone'],
                address: documentSnapshot['customerAddress'],
                date: date,
              ),
            );
          } else if (documentSnapshot['status'] == 'r') {
            Timestamp timestamp = documentSnapshot['date'];
            DateTime dateTime = timestamp.toDate();
            String time =
                '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
            String date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
            rejected.add(
              DeclineWidget(
                time: time,
                timing: documentSnapshot['urgentBooking'] == true
                    ? 'Urgent Booking'
                    : documentSnapshot['timeIndex'],
                serviceName: documentSnapshot['serviceName'],
                phone: documentSnapshot['customerPhone'],
                address: documentSnapshot['customerAddress'],
                date: date,
              ),
            );
          }
        }
      }

      pending.sort((a, b) {
        int c1 = b.id.compareTo(a.id);
        int c2 = b.date.compareTo(a.date);

        // You need to return a value based on the comparison
        if (c1 != 0) {
          return c1;
        } else {
          return c2;
        }
      });

      completed.sort((a, b) {
        int c1 = b.date.compareTo(a.date);
        int c2 = b.time.compareTo(a.time);

        // You need to return a value based on the comparison
        if (c1 != 0) {
          return c1;
        } else {
          return c2;
        }
      });

      rejected.sort((a, b) {
        int c1 = b.date.compareTo(a.date);
        int c2 = b.time.compareTo(a.time);

        // You need to return a value based on the comparison
        if (c1 != 0) {
          return c1;
        } else {
          return c2;
        }
      });
    } catch (e) {
      log("Error fetching data: $e");
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
    // Update the state or perform other actions as needed
    setState(() {
      showHalfPage = false;
    });
    Navigator.of(context).popUntil(
      (route) {
        return route is TechnicianHomeScreen;
      },
    );
  }

  Future<List<String>> fetchNotificationsFromFirestore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('technicians')
          .doc(_user!.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      List<String> notifications =
          querySnapshot.docs.map((doc) => doc['message'].toString()).toList();
      return notifications;
    } catch (error) {
      log('Error fetching notifications from Firestore: $error');
      return [];
    }
  }

  Future<void> openNotifications(BuildContext context) async {
    List<String> notifications = await fetchNotificationsFromFirestore();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotificationsScreen(notifications: notifications)));
  }

  @override
  Widget build(BuildContext context) {
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 17.h, vertical: 28.v),
                  child: Column(
                    children: [
                      _buildSubscribeRow(context),
                      SizedBox(
                        height: 19.v,
                      ),
                      _buildStatusRow(context),
                      SizedBox(
                        height: 20.v,
                      ),
                      _buildUsersList(context)
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
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
              AppbarTitle(text: 'My Bookings'),
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
              GestureDetector(
                onTap: () {
                  openNotifications(context);
                },
                child: AppbarTrailingImage(
                  imagePath: ImageConstant.imgGroup5139931,
                  margin: EdgeInsets.only(
                    left: 24.h,
                    right: 46.h,
                  ),
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
                  height: 60.adaptSize,
                  width: 60.adaptSize,
                  radius: BorderRadius.circular(25.h),
                ),
                SizedBox(height: 10.v),
                SizedBox(
                  width: 166.h,
                  child: Text(
                    "Get works around from you...",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: appTheme.gray80001,
                      fontSize: 15.fSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
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

  Widget _buildStatusRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 3.h, right: 11.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      decoration: AppDecoration.outlineBluegray100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          screenId == 'p' || screenId == 's'
              ? Container(
                  width: 80.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                  decoration: AppDecoration.fillPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL5),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 16.fSize,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      screenId = 'p';
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.v, bottom: 2.v),
                    child: Text(
                      "Pending",
                      style: TextStyle(
                        color: appTheme.gray500,
                        fontSize: 16.fSize,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
          screenId == 'c'
              ? Container(
                  width: 100.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                  decoration: AppDecoration.fillPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL5),
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 16.fSize,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      screenId = 'c';
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.v, bottom: 2.v),
                    child: Text(
                      "Completed",
                      style: TextStyle(
                        color: appTheme.gray500,
                        fontSize: 16.fSize,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
          screenId == 'r'
              ? Container(
                  width: 85.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                  decoration: AppDecoration.fillPrimary.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderTL5),
                  child: Text(
                    "Rejected",
                    style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 16.fSize,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      screenId = 'r';
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.v, bottom: 2.v),
                    child: Text(
                      "Rejected",
                      style: TextStyle(
                        color: appTheme.gray500,
                        fontSize: 16.fSize,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context) {
    log(completed.length.toString());
    log(rejected.length.toString());
    log(pending.length.toString());
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10.h, right: 7.h),
        child: (screenId == 'c' && completed.isEmpty) ||
                ((screenId == 'p' || screenId == 's') && pending.isEmpty) ||
                (screenId == 'r' && rejected.isEmpty)
            ? Column(
                children: [
                  SizedBox(
                    height: 230.v,
                  ),
                  Text(
                    screenId == 'c'
                        ? 'No completed bookings yet..'
                        : screenId == 'r'
                            ? 'No rejected bookings yet..'
                            : 'No pending bookings yet',
                    style: TextStyle(color: Colors.black, fontSize: 20.fSize),
                  ),
                ],
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 19.v,
                  );
                },
                itemCount: screenId == 'c'
                    ? completed.length
                    : screenId == 'p' || screenId == 's'
                        ? pending.length
                        : rejected.length,
                itemBuilder: (context, index) {
                  if (screenId == 'c') {
                    return CompletedWidget(
                      time: completed[index].time,
                      timing: completed[index].timing,
                      serviceName: completed[index].serviceName,
                      phone: completed[index].phone,
                      address: completed[index].address,
                      date: completed[index].date,
                    );
                  } else if (screenId == 'p' || screenId == 's') {
                    return PendingWidget(
                      location: pending[index].location,
                      serviceName: pending[index].serviceName,
                      timing: pending[index].timing,
                      docName: pending[index].docName,
                      id: pending[index].id,
                      phone: pending[index].phone,
                      address: pending[index].address,
                      date: pending[index].date,
                    );
                  } else {
                    return DeclineWidget(
                      time: rejected[index].time,
                      timing: rejected[index].timing,
                      serviceName: rejected[index].serviceName,
                      phone: rejected[index].phone,
                      address: rejected[index].address,
                      date: rejected[index].date,
                    );
                  }
                },
              ),
      ),
    );
  }
}
