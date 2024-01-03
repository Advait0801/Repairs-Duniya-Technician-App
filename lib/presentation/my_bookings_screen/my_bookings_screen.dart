import '../my_bookings_screen/widgets/userprofilelist2_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/widgets/app_bar/appbar_title.dart';
import 'package:technician_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:technician_app/widgets/app_bar/custom_app_bar.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({Key? key})
      : super(
          key: key,
        );

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
                        SizedBox(height: 19.v),
                        _buildFrameRow(context),
                        SizedBox(height: 20.v),
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

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.v),
      decoration: AppDecoration.gradientPrimaryToGray,
      child: Column(
        children: [
          SizedBox(height: 12.v),
          CustomAppBar(
            height: 37.v,
            title: Padding(
              padding: EdgeInsets.only(left: 26.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 3.v,
                          bottom: 5.v,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 27.h,
                                child: Divider(),
                              ),
                            ),
                            SizedBox(height: 3.v),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 27.h,
                                child: Divider(
                                  endIndent: 6.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.v),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 27.h,
                                child: Divider(),
                              ),
                            ),
                            SizedBox(height: 3.v),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 27.h,
                                child: Divider(
                                  endIndent: 6.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppbarTitle(
                        text: "My Bookings",
                        margin: EdgeInsets.only(left: 42.h),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgGroup,
                margin: EdgeInsets.only(
                  left: 38.h,
                  top: 3.v,
                  right: 10.h,
                ),
              ),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgGroup5139931,
                margin: EdgeInsets.only(
                  left: 40.h,
                  right: 48.h,
                ),
              ),
            ],
          ),
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
                    style: CustomTextStyles.labelLargeInterGray80001.copyWith(
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
  Widget _buildFrameRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 3.h,
        right: 11.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      decoration: AppDecoration.outlineBluegray100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 5.v,
              bottom: 2.v,
            ),
            child: Text(
              "Pending",
              style: CustomTextStyles.bodyLargeOpenSansGray500,
            ),
          ),
          Container(
            width: 98.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 2.v,
            ),
            decoration: AppDecoration.fillPrimary.copyWith(
              borderRadius: BorderRadiusStyle.customBorderTL5,
            ),
            child: Text(
              "Completed",
              style: CustomTextStyles.bodyLargeOpenSansOnError,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.v,
              right: 1.h,
              bottom: 2.v,
            ),
            child: Text(
              "Rejected",
              style: CustomTextStyles.bodyLargeOpenSansGray500,
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
        padding: EdgeInsets.only(
          left: 10.h,
          right: 7.h,
        ),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          separatorBuilder: (
            context,
            index,
          ) {
            return SizedBox(
              height: 19.v,
            );
          },
          itemCount: 4,
          itemBuilder: (context, index) {
            return Userprofilelist2ItemWidget();
          },
        ),
      ),
    );
  }
}
