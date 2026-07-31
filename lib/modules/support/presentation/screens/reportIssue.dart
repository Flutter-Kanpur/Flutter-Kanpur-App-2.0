import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_dotter_rectangle.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class ReportAnIssueScreen extends StatefulWidget {
  const ReportAnIssueScreen({super.key});

  @override
  State<ReportAnIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportAnIssueScreen> {
  String? selectedIssue;
  PlatformFile? pickedFile;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            translate(context, "profile_support.title"),
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.blackBase,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.h16,
                  right: AppSpacing.h16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [_buildReportForm()],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReportForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.v10),
        _buildSubtitle(),
        SizedBox(height: AppSpacing.v22),
        _buildIssueField(),
        SizedBox(height: AppSpacing.v22),
        _buildDescriptionField(),
        SizedBox(height: AppSpacing.v22),
        _buildUploadSection(),
        SizedBox(height: AppSpacing.v20),
        _buildUploadCards(),
        SizedBox(height: AppSpacing.v10),
        _buildSubmitButton(),
        SizedBox(height: AppSpacing.v2),
        _buildCancelButton(),
        SizedBox(height: AppSpacing.v6),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Text(
      translate(context, "profile_support.subtitle"),
      style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
    );
  }

  Widget _buildIssueField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(context, "profile_support.issue_type"),
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        ),
        SizedBox(height: AppSpacing.v10),
        GestureDetector(
          onTap: () {
            showCustomDropdown(
              context: context,
              items: <String>[
                translate(context, "profile_support.issueTypes.bug_report"),
                translate(context, "profile_support.issueTypes.account_issue"),
                translate(context, "profile_support.issueTypes.payment_issue"),
                translate(
                  context,
                  "profile_support.issueTypes.feature_request",
                ),
                translate(context, "profile_support.issueTypes.other"),
              ],
              selectedValue: selectedIssue,
              onSelected: (value) => setState(() => selectedIssue = value),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h16,
              vertical: AppSpacing.v16,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteBase.withOpacity(0.9),
              borderRadius: AppRadius.all04,
              border: Border.all(color: AppBorders.secondary),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedIssue ??
                        translate(
                          context,
                          "profile_support.select_placeholder",
                        ),
                    style: selectedIssue == null
                        ? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.neutral300,
                          )
                        : AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.blackBase,
                          ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(context, "profile_support.describe_issue"),
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        ),
        SizedBox(height: AppSpacing.v10),
        TextFormField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: translate(context, "profile_support.describe_issue_hint"),
            hintStyle: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.blackBase)
                .copyWith(color: AppColors.neutral300),
            filled: true,
            fillColor: AppColors.whiteBase.withOpacity(0.9),
            contentPadding: AppSpacing.symmetric(
              horizontal: AppSpacing.h16,
              vertical: AppSpacing.v6,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.all04,
              borderSide: BorderSide(color: AppBorders.secondary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.all04,
              borderSide: BorderSide(color: AppBorders.secondary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.all04,
              borderSide: const BorderSide(color: AppBorders.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(context, "profile_support.upload_optional"),
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        ),
        SizedBox(height: AppSpacing.v10),
        Container(
          width: double.infinity,
          child: DottedRoundedRect(
            radius: 14.r,
            strokeWidth: 1.2,
            color: AppColors.neutral100,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h10,
              vertical: AppSpacing.v16,
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/upload_icon.svg',
                  width: 18.w,
                  height: 18.w,
                  color: AppColors.neutral300,
                ),
                SizedBox(height: AppSpacing.v10),
                Text(
                  translate(context, "profile_support.choose_file_hint"),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.blackBase)
                      .copyWith(color: AppColors.neutral300),
                ),
                SizedBox(height: AppSpacing.v12),
                OutlinedButton(
                  onPressed: _pickFile,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.blackBase,
                    side: BorderSide(color: AppBorders.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.all02,
                    ),
                    padding: AppSpacing.symmetric(
                      horizontal: AppSpacing.h18,
                      vertical: AppSpacing.v8,
                    ),
                  ),
                  child: Text(
                    translate(context, "profile_support.browse_files"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCards() {
    return Column(
      children: [
        if (pickedFile != null) ...[
          SizedBox(height: AppSpacing.v10),
          Row(
            children: [
              Expanded(
                child: Text(
                  pickedFile!.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.blackBase,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.h12),
              isUploading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : ElevatedButton(
                      onPressed: _uploadFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.all02,
                        ),
                        padding: AppSpacing.symmetric(
                          horizontal: AppSpacing.h12,
                          vertical: AppSpacing.v8,
                        ),
                      ),
                      child: Text(
                        translate(context, "profile_support.upload"),
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.blackBase)
                            .copyWith(color: AppColors.whiteBase),
                      ),
                    ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: EdgeInsets.only(
        left: AppSpacing.h10,
        right: AppSpacing.h10,
        bottom: AppSpacing.v10,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientButton(
            height: 45.h,
            textStyle: AppTextStyles.titleMedium.copyWith(
              color: AppColors.whiteBase,
            ),
            text: translate(context, "profile_support.submit_report"),
            onTap: () {},
          ),
          Positioned(
            right: 60.w,
            child: Container(
              padding: EdgeInsets.only(left: AppSpacing.h6),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.whiteBase,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          translate(context, "profile_support.cancel"),
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(withData: true);
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          pickedFile = result.files.first;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('File pick error: $e');
    }
  }

  Future<void> _uploadFile() async {
    if (pickedFile == null) return;
    setState(() => isUploading = true);
    try {
      // TODO: Replace this mock upload with real upload logic (send bytes/path to backend)
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate(context, 'profile_support.uploaded_success')),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(translate(context, 'profile_support.uploaded_failed')),
        ),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }
}

Future<void> showCustomDropdown({
  required BuildContext context,
  required List<String> items,
  required String? selectedValue,
  required Function(String) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        margin: AppSpacing.all(AppSpacing.h16),
        padding: AppSpacing.vertical(AppSpacing.v12),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all06,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.v6),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item == selectedValue;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSelected(item);
              },
              child: Container(
                margin: AppSpacing.horizontal(AppSpacing.h12),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: AppSpacing.v16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary100 : Colors.transparent,
                  borderRadius: AppRadius.all04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.blackBase,
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check, size: 20),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
