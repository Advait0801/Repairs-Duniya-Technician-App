import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/my_bookings_screen/widgets/completed_widget.dart';
import 'package:technician_app/presentation/profile_screen/profile_screen.dart';
import 'package:technician_app/widgets/app_bar/appbar_title.dart';
import 'package:technician_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

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
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.h, vertical: 28.v),
                    child: Column(
                      children: [
                        _buildSubscribeRow(context),
                        SizedBox(height: 19.v),
                        _buildStatusRow(context),
                        SizedBox(height: 20.v),
                        _buildUserProfileList(context)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
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
                    radius: BorderRadius.circular(22.h)),
                SizedBox(height: 10.v),
                SizedBox(
                    width: 166.h,
                    child: Text("To get more works subscribe to our gold plan",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: appTheme.gray80001,
                            fontSize: 12.fSize,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500))),
                SizedBox(height: 8.v),
                CustomElevatedButton(
                    height: 36.v,
                    width: 157.h,
                    text: "Subscribe",
                    buttonStyle: CustomButtonStyles.outlinePrimaryTL13)
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
  Widget _buildStatusRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 3.h, right: 11.h),
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      decoration: AppDecoration.outlineBluegray100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 5.v, bottom: 2.v),
              child: Text("Pending",
                  style: TextStyle(
                      color: appTheme.gray500,
                      fontSize: 16.fSize,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400))),
          Container(
              width: 98.h,
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
              decoration: AppDecoration.fillPrimary
                  .copyWith(borderRadius: BorderRadiusStyle.customBorderTL5),
              child: Text("Completed",
                  style: TextStyle(
                      color: theme.colorScheme.onError,
                      fontSize: 16.fSize,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400))),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(top: 5.v, right: 1.h, bottom: 2.v),
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
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildUserProfileList(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.only(left: 10.h, right: 7.h),
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 19.v);
                },
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const CompletedWidget();
                })));
  }
}
