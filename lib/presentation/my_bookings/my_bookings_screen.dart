// ignore_for_file: unused_field, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/my_bookings/widgets/completed_widget.dart';
import 'package:technician_app/presentation/my_bookings/widgets/decline_widget.dart';
import 'package:technician_app/presentation/my_bookings/widgets/pending_widget.dart';
import 'package:technician_app/presentation/profile_screen/profile_screen.dart';
import 'package:technician_app/widgets/app_bar/appbar_title.dart';
import 'package:technician_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';
import 'package:technician_app/widgets/half_page.dart';

class MyBookingsScreen extends StatefulWidget {
  MyBookingsScreen({super.key, required this.id});
  String id;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String screenId = '';
  bool showHalfPage = true;
  static List<PendingWidget> pending = [
    PendingWidget(id: 'p'),
    PendingWidget(id: 'p'),
    PendingWidget(id: 'p'),
    PendingWidget(id: 'p'),
  ];
  static List<CompletedWidget> completed = [
    const CompletedWidget(),
    const CompletedWidget(),
    const CompletedWidget(),
  ];
  static List<DeclineWidget> rejected = [
    const DeclineWidget(),
    const DeclineWidget(),
    const DeclineWidget(),
  ];

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
      });
    });
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
    return Expanded(
        child: Padding(
      padding: EdgeInsets.only(left: 10.h, right: 7.h),
      child: ListView.separated(
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
            return const CompletedWidget();
          } else if (screenId == 'p') {
            return PendingWidget(
              id: 'p',
            );
          } else if (screenId == 's') {
            return PendingWidget(id: 's');
          } else {
            return const DeclineWidget();
          }
        },
      ),
    ));
  }
}
