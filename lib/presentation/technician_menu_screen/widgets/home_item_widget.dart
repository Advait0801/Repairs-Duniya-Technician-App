import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';

// ignore: must_be_immutable
class HomeItemWidget extends StatelessWidget {
  const HomeItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.h,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
            top: 88.v,
            bottom: 1.v,
          ),
          child: Text(
            "Home",
            style: CustomTextStyles.bodyMediumOpenSansOnError,
          ),
        ),
      ),
    );
  }
}
