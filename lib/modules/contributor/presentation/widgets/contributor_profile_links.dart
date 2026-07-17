import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_text_field.dart';
import 'package:easy_localization/easy_localization.dart';

class ContributorProfileLinks extends StatelessWidget {
  const ContributorProfileLinks({
    super.key,
    required this.githubController,
    required this.linkedinController,
    required this.portfolioController,
    this.validator,
  });

  final TextEditingController githubController;
  final TextEditingController linkedinController;
  final TextEditingController portfolioController;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FkTextField(
          controller: githubController,
          hint: "contributor.githubLink".tr(),
          label: '',
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        FkTextField(
          controller: linkedinController,
          hint: "contributor.linkedinLink".tr(),
          label: '',
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        FkTextField(
          controller: portfolioController,
          hint: "contributor.portfolioWebsite".tr(),
          label: '',
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
