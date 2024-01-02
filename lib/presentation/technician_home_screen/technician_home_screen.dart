import 'package:flutter/foundation.dart';
import 'package:technician_app/presentation/technician_home_screen/widgets/userprofilelist_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/widgets/app_bar/appbar_title.dart';
import 'package:technician_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:technician_app/widgets/app_bar/custom_app_bar.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';

class TechnicianHomeScreen extends StatefulWidget {
  const TechnicianHomeScreen({super.key});

  @override
  State<TechnicianHomeScreen> createState() => _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends State<TechnicianHomeScreen> {
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
                        _buildBookingColumn(context),
                        SizedBox(height: 72.v),
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
              AppbarTitle(text: 'Hello'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgGroup,
                margin: EdgeInsets.only(
                  left: 38.h,
                  top: 3.v,
                ),
              ),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgGroup5139931,
                margin: EdgeInsets.only(left: 24.h, right: 46.h),
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
      decoration: AppDecoration.gradientOrangeAToOnError.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
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
                  radius: BorderRadius.circular(
                    22.h,
                  ),
                ),
                SizedBox(height: 10.v),
                SizedBox(
                  width: 166.h,
                  child: Text(
                    "To get more works subscribe to our gold plan",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.labelLargeInterGray800.copyWith(
                      height: 1.17,
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
                CustomElevatedButton(
                  height: 36.v,
                  width: 157.h,
                  text: "Subscribe",
                  buttonStyle: CustomButtonStyles.outlinePrimaryTL13,
                  buttonTextStyle: theme.textTheme.labelLarge!,
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgImage90,
            height: 163.adaptSize,
            width: 163.adaptSize,
            margin: EdgeInsets.only(top: 3.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBookingColumn(BuildContext context) {
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
                            "Shaik Abdullha",
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
                            "AC - AC installation",
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
                            "22/06/2023",
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
                            "Morning",
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
                            "New Delhi - 110001, India",
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
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "03:00",
                              style: theme.textTheme.titleLarge,
                            ),
                            TextSpan(
                              text: "min",
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
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
          itemCount: 3,
          itemBuilder: (context, index) {
            return const UserprofilelistItemWidget();
          },
        ),
      ),
    );
  }
}
