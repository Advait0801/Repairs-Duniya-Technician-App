import 'package:flutter/material.dart';
import 'package:technician_app/core/app_export.dart';
import 'package:technician_app/presentation/decline_screen/widgets/decline_widget.dart';

// ignore_for_file: must_be_immutable
class DeclinedScreen extends StatefulWidget {
  const DeclinedScreen({Key? key})
      : super(
          key: key,
        );

  @override
  DeclinedScreenState createState() => DeclinedScreenState();
}

class DeclinedScreenState extends State<DeclinedScreen>
    with AutomaticKeepAliveClientMixin<DeclinedScreen> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.colorScheme.onError,
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnError,
          child: Column(
            children: [
              SizedBox(height: 20.v),
              _buildUserProfile(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserProfile(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.h),
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
            return const DeclineWidget();
          },
        ),
      ),
    );
  }
}
