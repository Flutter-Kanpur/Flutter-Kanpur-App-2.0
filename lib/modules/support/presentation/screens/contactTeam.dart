import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/edit_profile_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class ContactCommunityTeamScreen extends StatefulWidget {
  const ContactCommunityTeamScreen({super.key});

  @override
  State<ContactCommunityTeamScreen> createState() =>
      _ContactCommunityTeamScreenState();
}

class _ContactCommunityTeamScreenState
    extends State<ContactCommunityTeamScreen> {
  String? selectedSubject;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Focus nodes and field keys to mimic sign_in_v2 scrolling behavior
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();

  final GlobalKey _nameFieldKey = GlobalKey();
  final GlobalKey _emailFieldKey = GlobalKey();
  final GlobalKey _messageFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_scrollToFocusedField);
    _emailFocusNode.addListener(_scrollToFocusedField);
    _messageFocusNode.addListener(_scrollToFocusedField);
  }

  void _scrollToFocusedField() {
    final node = _nameFocusNode.hasFocus
        ? _nameFocusNode
        : _emailFocusNode.hasFocus
        ? _emailFocusNode
        : _messageFocusNode;

    final key = _nameFocusNode.hasFocus
        ? _nameFieldKey
        : _emailFocusNode.hasFocus
        ? _emailFieldKey
        : _messageFieldKey;

    if (node.hasFocus && (key as GlobalKey).currentContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          (key).currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_scrollToFocusedField);
    _emailFocusNode.removeListener(_scrollToFocusedField);
    _messageFocusNode.removeListener(_scrollToFocusedField);
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _messageFocusNode.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: implement send logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(translate(context, 'contactCommunity.sendMessage'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            translate(context, 'contactCommunity.title'),
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w600),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.s07,
                  right: AppSpacing.s07,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildContactForm(),
                      ],
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

  Widget _buildContactForm() {
    final subjects = [
      translate(context, 'contactCommunity.subjectGeneral'),
      translate(context, 'contactCommunity.subjectTechnical'),
      translate(context, 'contactCommunity.subjectPartnership'),
      translate(context, 'contactCommunity.subjectOther'),
    ];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.s05),
          _buildHeader(),
          SizedBox(height: AppSpacing.s10),
          _buildSubjectField(subjects),
          SizedBox(height: AppSpacing.s09),
          _buildMessageField(),
          SizedBox(height: AppSpacing.s09),
          _buildNameField(),
          SizedBox(height: AppSpacing.s09),
          _buildEmailField(),
          SizedBox(height: AppSpacing.s09),
          _buildSendButton(),
          SizedBox(height: AppSpacing.s03),
          _buildCancelButton(),
          SizedBox(height: AppSpacing.s02),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(context, 'contactCommunity.subtitle'),
          style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSubjectField(List<String> subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translate(context, 'contactCommunity.subject'),
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)),
        SizedBox(height: AppSpacing.s05),
        GestureDetector(
          onTap: () {
            showCustomDropdown(
              context: context,
              items: subjects,
              selectedValue: selectedSubject,
              onSelected: (value) => setState(() => selectedSubject = value),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
            decoration: BoxDecoration(
              color: AppColors.whiteBase.withOpacity(0.9),
              borderRadius: AppRadius.all04,
              border: Border.all(color: AppBorders.secondary),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedSubject ??
                        translate(
                            context, 'contactCommunity.selectPlaceholder'),
                    style: selectedSubject == null
                        ? AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutral300)
                        : AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase),
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

  Widget _buildMessageField() {
    return Container(
      key: _messageFieldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translate(context, 'contactCommunity.message'),
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)),
          SizedBox(height: AppSpacing.s05),
          TextFormField(
            focusNode: _messageFocusNode,
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: translate(context, 'contactCommunity.messageHint'),
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase)
                  .copyWith(color: AppColors.neutral300),
              filled: true,
              fillColor: AppColors.whiteBase.withOpacity(0.9),
              contentPadding:
              AppSpacing.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s06),
              border: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                BorderSide(color: AppBorders.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                BorderSide(color: AppBorders.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                const BorderSide(color: AppBorders.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      key: _nameFieldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translate(context, 'contactCommunity.fullName'),
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)),
          SizedBox(height: AppSpacing.s05),
          TextFormField(
            focusNode: _nameFocusNode,
            controller: _nameController,
            decoration: InputDecoration(
              hintText: translate(context, 'contactCommunity.nameHint'),
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase)
                  .copyWith(color: AppColors.neutral300),
              filled: true,
              fillColor: AppColors.whiteBase.withOpacity(0.9),
              contentPadding:
              EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
              border: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                BorderSide(color: AppBorders.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                BorderSide(color: AppBorders.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                const BorderSide(color: AppBorders.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return translate(context, 'validation.nameRequired');
              }
              if (value.trim().length < 2) {
                return translate(context, 'validation.nameTooShort');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      key: _emailFieldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translate(context, 'contactCommunity.email'),
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)),
          SizedBox(height: AppSpacing.s05),
          TextFormField(
            focusNode: _emailFocusNode,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: translate(context, 'contactCommunity.emailHint'),
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase)
                  .copyWith(color: AppColors.neutral300),
              filled: true,
              fillColor: AppColors.whiteBase.withOpacity(0.9),
              contentPadding:
              EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
              border: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                BorderSide(color: AppBorders.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                BorderSide(color: AppBorders.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.all04,
                borderSide:
                const BorderSide(color: AppBorders.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return translate(context, 'validation.emailRequired');
              }
              final emailRegEx = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
              if (!emailRegEx.hasMatch(value.trim())) {
                return translate(context, 'validation.emailInvalid');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      margin: AppSpacing.horizontal(AppSpacing.s09),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientButton(
            height: 50.h,
            textStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.whiteBase),
            text: translate(context, 'contactCommunity.sendMessage'),
            onTap: _submit,
          ),
          Positioned(
            right: 60.w,
            child: const Icon(
              Icons.arrow_forward,
              color: AppColors.whiteBase,
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
          translate(context, 'contactCommunity.cancel'),
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        ),
      ),
    );
  }
}