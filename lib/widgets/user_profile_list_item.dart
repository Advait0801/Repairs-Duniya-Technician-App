import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';

class UserprofilelistItemWidget extends StatelessWidget {
  const UserprofilelistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 23.h,
        vertical: 20.v,
      ),
      decoration: AppDecoration.gradientOnErrorToBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
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
            height: 122.v,
            width: 121.h,
            margin: EdgeInsets.symmetric(vertical: 22.v),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 9.h),
                    child: Text(
                      "Completed",
                      style: CustomTextStyles.labelLargeInterErrorContainer,
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgImage73,
                  height: 113.v,
                  width: 121.h,
                  alignment: Alignment.topCenter,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
