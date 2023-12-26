import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';
import 'package:technician_app/widgets/custom_text_form_field.dart';

class ConfirmLocationScreen extends StatelessWidget {
  ConfirmLocationScreen({super.key});

  TextEditingController locationController = TextEditingController();
  // static const LatLng _pGooglePlex = LatLng(37.4233, -122.0848);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: GoogleMap(
  //       initialCameraPosition: CameraPosition(
  //         target: _pGooglePlex,
  //         zoom: 13,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: 894.v,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgScreenshot120,
                height: 1077.v,
                width: 430.h,
                alignment: Alignment.bottomCenter,
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 2.v),
                    child: Column(
                      children: [
                        _buildPickALocationFrame(context),
                        SizedBox(height: 148.v),
                        CustomImageView(
                          imagePath: ImageConstant.imgVector22x20,
                          height: 50.v,
                          width: 46.h,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 171.h),
                        ),
                        SizedBox(height: 197.v),
                        _buildConfirmLocationFrame(context),
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
  Widget _buildPickALocationFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.gradientPrimaryToGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 17.v),
          Text(
            "Pick a location",
            style: CustomTextStyles.headlineSmallOnError,
          ),
          SizedBox(height: 9.v),
          CustomTextFormField(
            onChanged: (value) {},
            controller: locationController,
            hintText: "Willowbrook Heights, New Delhi - 110001, India",
            textInputAction: TextInputAction.done,
            prefix: Container(
              margin: EdgeInsets.fromLTRB(19.h, 9.v, 8.h, 9.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgVector22x20,
                height: 22.v,
                width: 20.h,
              ),
            ),
            prefixConstraints: BoxConstraints(
              maxHeight: 40.v,
            ),
            suffix: Container(
              margin: EdgeInsets.fromLTRB(30.h, 6.v, 12.h, 6.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgDownChevron,
                height: 28.v,
                width: 24.h,
              ),
            ),
            suffixConstraints: BoxConstraints(
              maxHeight: 40.v,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 11.v),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildConfirmLocationFrame(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 23.h,
        vertical: 24.v,
      ),
      decoration: AppDecoration.gradientOnErrorToGray,
      child: Column(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImage72,
            height: 66.adaptSize,
            width: 66.adaptSize,
          ),
          SizedBox(height: 3.v),
          Text(
            "Confirm your location",
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 18.v),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.h),
            padding: EdgeInsets.symmetric(
              horizontal: 31.h,
              vertical: 14.v,
            ),
            decoration: AppDecoration.fillGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder15,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgVector22x20,
                  height: 24.v,
                  width: 22.h,
                  margin: EdgeInsets.only(
                    top: 1.v,
                    bottom: 9.v,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 261.h,
                    margin: EdgeInsets.only(
                      left: 19.h,
                      top: 1.v,
                      right: 6.h,
                    ),
                    child: Text(
                      "123, Maplewood Avenue, Willowbrook Heights, New Delhi - 110001, India",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodySmallGray800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.v),
          CustomElevatedButton(
            text: "Yes, that’s my location",
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientPrimaryToGrayDecoration,
          ),
          SizedBox(height: 19.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgArrowLeft,
                height: 20.adaptSize,
                width: 20.adaptSize,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: Text(
                  "Back",
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.v),
        ],
      ),
    );
  }
}
