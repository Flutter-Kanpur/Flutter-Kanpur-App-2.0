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
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/utils/network_connectivity_service.dart';
import 'package:flutter_knp_mobile_app_v2/modules/support/data/support_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/shared/screens/app_feedback_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_knp_mobile_app_v2/core/utils/image_compress_helper.dart';

class ReportAnIssueScreen extends StatefulWidget {
  const ReportAnIssueScreen({super.key});

  @override
  State<ReportAnIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportAnIssueScreen> {
  String? selectedIssue;
  PlatformFile? pickedFile;
  Uint8List? previewBytes;
  double uploadProgress = 0; // 0.0 → 1.0
  bool isUploadComplete = false;
  bool isUploadingFile = false;
  bool isSubmitting = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showReportSuccess() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.push(
      RouteNames.feedback,
      extra: AppFeedbackScreen(
        image: AssetsPath.successTick,
        title: 'reportSubmitted.title'.tr(),
        subtitle: 'reportSubmitted.subtitle'.tr(),
        buttonText: 'reportSubmitted.reportAnother'.tr(),
        buttonIcon: Icons.arrow_back,
        isSuccess: true,
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _resetForm(); // optional but better UX for "another" report
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.reportAnIssue);
          }
        },
        secondaryText: 'reportSubmitted.goToProfile'.tr(),
        onSecondaryPressed: () => context.go(RouteNames.profile),
      ),
    );
  }

  void _showReportFailure() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.push(
      RouteNames.feedback,
      extra: AppFeedbackScreen(
        image: AssetsPath.failureImage,
        title: 'reportFailed.title'.tr(),
        subtitle: 'reportFailed.subtitle'.tr(),
        buttonText: 'reportFailed.tryAgain'.tr(),
        isSuccess: false,
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _resetForm(); // optional but better UX for "another" report
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(RouteNames.reportAnIssue);
          }
        },
      ),
    );
  }

  void _resetForm() {
    setState(() {
      selectedIssue = null;
      pickedFile = null;
      previewBytes = null;
      uploadProgress = 0;
      isUploadComplete = false;
      isUploadingFile = false;
      isSubmitting = false;
    });
    _descriptionController.clear();
  }

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
          controller: _descriptionController,
          autofocus: false,
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
                  AssetsPath.uploadIcon, // assets/icons/upload_file.svg
                  width: 18.w,
                  height: 18.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.neutral300,
                    BlendMode.srcIn,
                  ),
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
                  onPressed: isSubmitting ? null : _pickFile,
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
    if (pickedFile == null) return const SizedBox.shrink();

    final totalBytes = pickedFile!.size;
    final total = _readableSize(totalBytes);
    final loadedBytes = (totalBytes * uploadProgress).round();
    final loaded = _readableSize(loadedBytes);

    final uploading = isUploadingFile || (isSubmitting && !isUploadComplete);
    // Or simpler for pick-only progress:
    // final uploading = isUploadingFile;
    final completed = isUploadComplete && !isUploadingFile;

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.v10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSpacing.h12),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all04,
          border: Border.all(color: AppBorders.secondary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  AssetsPath.fileIcon,
                  width: 40.w,
                  height: 40.w,
                ),
                SizedBox(width: AppSpacing.h12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickedFile!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackBase,
                        ),
                      ),
                      SizedBox(height: AppSpacing.v4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '$loaded of $total',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.neutral400,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSpacing.h8),
                          SvgPicture.asset(
                            completed
                                ? AssetsPath.greenTick
                                : AssetsPath.yellowFileLoader,
                            width: 14.w,
                            height: 14.w,
                          ),
                          SizedBox(width: AppSpacing.h4),
                          Text(
                            completed
                                ? translate(
                                    context,
                                    'profile_support.completed',
                                  )
                                : translate(
                                    context,
                                    'profile_support.uploading',
                                  ),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: uploading ? null : _clearFile,
                  icon: SvgPicture.asset(
                    uploading ? AssetsPath.crossIcon : AssetsPath.dustbin,
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.v10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: uploadProgress.clamp(0.0, 1.0), // real 0→1 progress
                minHeight: 6,
                backgroundColor: AppColors.primary100,
                color: AppColors.primary500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearFile() {
    setState(() {
      pickedFile = null;
      previewBytes = null;
      uploadProgress = 0;
      isUploadingFile = false;
      isUploadComplete = false;
    });
  }

  String _readableSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} kb';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = file.extension?.toLowerCase();
    if (ext == null || !['jpg', 'jpeg', 'png'].contains(ext)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate(context, 'profile_support.onlyImagesAllowed'),
          ),
        ),
      );
      return;
    }

    if (file.bytes == null || file.bytes!.isEmpty) return;

    if (file.bytes == null || file.bytes!.isEmpty) return;

    setState(() {
      pickedFile = file;
      previewBytes = null;
      isUploadingFile = true;
      isUploadComplete = false;
      uploadProgress = 0;
    });

    final compressedFuture = ImageCompressHelper.compressForUpload(
      Uint8List.fromList(file.bytes!),
    );
    final progressFuture = _animateUploadProgress();

    final compressed = await compressedFuture;
    await progressFuture;
    if (!mounted) return;

    if (compressed == null || compressed.isEmpty) {
      setState(() {
        pickedFile = null;
        previewBytes = null;
        isUploadingFile = false;
        isUploadComplete = false;
        uploadProgress = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not process image. Try another file.'),
        ),
      );
      return;
    }

    setState(() {
      previewBytes = compressed;
      isUploadingFile = false;
      isUploadComplete = true;
      uploadProgress = 1;
    });
  }

  Future<void> _animateUploadProgress() async {
    const steps = 20;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted || pickedFile == null) return;
      setState(() => uploadProgress = i / steps);
    }
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
            isLoading: isSubmitting,
            onTap: isSubmitting ? () {} : _submitReport,
          ),
          if (!isSubmitting)
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

  Future<void> _submitReport() async {
    if (isSubmitting) return;

    if (selectedIssue == null || selectedIssue!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate(context, 'profile_support.select_placeholder'),
          ),
        ),
      );
      return;
    }

    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate(context, 'profile_support.describe_issue_hint'),
          ),
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final online = await NetworkConnectivityService.instance
          .checkInternetConnection();
      if (!mounted) return;
      if (!online) {
        _showReportFailure();
        return;
      }

      String? attachmentBase64;
      String? attachmentFilename;
      String? attachmentContentType;

      if (pickedFile != null && previewBytes != null) {
        attachmentBase64 = base64Encode(previewBytes!);
        final baseName = pickedFile!.name.replaceAll(
          RegExp(r'\.(png|jpg|jpeg)$', caseSensitive: false),
          '',
        );
        attachmentFilename = '$baseName.jpg';
        attachmentContentType = 'image/jpeg';
      }

      final ok = await SupportService().sendIssueReport(
        issueType: selectedIssue!,
        description: description,
        attachmentBase64: attachmentBase64,
        attachmentFilename: attachmentFilename,
        attachmentContentType: attachmentContentType,
      );

      if (!mounted) return;
      ok ? _showReportSuccess() : _showReportFailure();
    } catch (_) {
      if (!mounted) return;
      _showReportFailure();
    } finally {
      if (mounted) setState(() => isSubmitting = false);
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
