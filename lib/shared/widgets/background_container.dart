import 'package:flutter/material.dart';
import '../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/gradiants.dart';
import '../../utils/text_styles.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(

        gradient: RadialGradient(radius: 0.53.r,colors: getBackgroundGradientColors())
      ),
      child: Column(
        children: [
          80.verticalSpace,
          _buildTitle(context),
          20.verticalSpace,
          _buildSubTitle(context),
          // 25.verticalSpace,
          // _buildJoinCommunity(),
          50.verticalSpace,
          _buildDashboardTitle(context),
        ],
      ),
    );
  }
}

Widget _buildTitle(BuildContext context) {
  return Text(translate(context, 'community.title'),
      textAlign: TextAlign.center, style: textStyle_45Bold());
}

Widget _buildSubTitle(BuildContext context) {
  return Text(translate(context, 'community.subtitle'),
      textAlign: TextAlign.center, style: textStyle_14());
}

Widget _buildDashboardTitle(BuildContext context) {
  return Column(
    children: [
      Text(translate(context, 'community.communityDashboard'),
          style: textStyle_16Bold()),
    ],
  );
}
