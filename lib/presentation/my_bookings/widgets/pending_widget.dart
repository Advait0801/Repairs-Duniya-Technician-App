import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/my_bookings/end_selfie_screen.dart';
import 'package:technician_app/presentation/my_bookings/start_selfie_screen.dart';
import 'package:technician_app/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PendingWidget extends StatefulWidget {
  PendingWidget({super.key, required this.id});
  final String id;

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget> {
  String screenId = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      screenId = widget.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.h,
        vertical: 19.v,
      ),
      decoration: AppDecoration.gradientOnErrorToBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 7.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: TextStyle(
                              color: appTheme.blueGray700,
                              fontSize: 13.740318298339844.fSize,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.v),
                    Row(
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
                            bottom: 2.v,
                          ),
                          child: Text(
                            "AC - AC installation",
                            style: TextStyle(
                              color: appTheme.blueGray700,
                              fontSize: 13.740318298339844.fSize,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
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
                            style: TextStyle(
                              color: appTheme.blueGray700,
                              fontSize: 13.740318298339844.fSize,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
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
                            style: TextStyle(
                              color: appTheme.blueGray700,
                              fontSize: 13.740318298339844.fSize,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
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
                            style: TextStyle(
                              color: appTheme.blueGray700,
                              fontSize: 12.fSize,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 37.v),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgImage89,
                        height: 94.v,
                        width: 97.h,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 19.v),
                      Padding(
                        padding: EdgeInsets.only(left: 18.h, right: 18.h),
                        child: Text(
                          "Pending",
                          style: TextStyle(
                            color: appTheme.red500,
                            fontSize: 13.740318298339844.fSize,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.v),
          screenId == 'p'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () async {
                        launchUrl(Uri.parse('tel://+918600008456'));
                      },
                      height: 49.v,
                      width: 157.h,
                      text: "Call",
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles
                          .gradientPrimaryToGrayTL13Decoration,
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        setState(() {
                          screenId = 's';
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const StartSelfieScreen()));
                      },
                      height: 49.v,
                      width: 157.h,
                      text: "Start",
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles
                          .gradientLightGreenAToLightGreenADecoration,
                      alignment: Alignment.bottomRight,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Started working..',
                      style: CustomTextStyles.labelLargeInterRed500,
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EndSelfieScreen()));
                      },
                      height: 49.v,
                      width: 157.h,
                      text: "Done",
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles
                          .gradientLightGreenAToLightGreenADecoration,
                      alignment: Alignment.bottomRight,
                    ),
                  ],
                ),
          SizedBox(height: 4.v),
        ],
      ),
    );
  }
}
