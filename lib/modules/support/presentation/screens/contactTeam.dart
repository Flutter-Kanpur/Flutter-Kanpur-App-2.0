import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/presentation/screens/pages/edit_profile_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';

import '../../../../shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/utils/network_connectivity_service.dart';
import 'package:flutter_knp_mobile_app_v2/modules/support/data/support_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/application/profile_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/domain/profile_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/shared/screens/app_feedback_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';

class ContactCommunityTeamScreen extends ConsumerStatefulWidget {
  const ContactCommunityTeamScreen({super.key});

  @override
  ConsumerState<ContactCommunityTeamScreen> createState() =>
      _ContactCommunityTeamScreenState();
}

class _ContactCommunityTeamScreenState
    extends ConsumerState<ContactCommunityTeamScreen> {
  bool _prefilled = false;
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
  bool isSubmitting = false;

 @override
void initState() {
  super.initState();
  _nameFocusNode.addListener(_scrollToFocusedField);
  _emailFocusNode.addListener(_scrollToFocusedField);
  _messageFocusNode.addListener(_scrollToFocusedField);

  ref.listenManual<AsyncValue<ProfileUser?>>(
    myProfileProvider,
    (previous, next) => next.whenData(_prefillOnce),
    fireImmediately: true,
  );
}
void _showContactSuccess() {
  context.push(
    RouteNames.feedback,
    extra: AppFeedbackScreen(
      image: AssetsPath.successTick,
      title: 'messageSent.title'.tr(),
      subtitle: 'messageSent.subtitle'.tr(),
      buttonText: 'messageSent.backToProfile'.tr(),
      buttonIcon: Icons.arrow_back,
      isSuccess: true,
      onPressed: () => context.go(RouteNames.profile),
    ),
  );
}

void _showContactFailure() {
  context.push(
    RouteNames.feedback,
    extra: AppFeedbackScreen(
      image: AssetsPath.failureImage,
      title: 'messageNotSent.title'.tr(),
      subtitle: 'messageNotSent.subtitle'.tr(),
      buttonText: 'messageNotSent.backToProfile'.tr(), 
      isSuccess: false,
      onPressed: () => context.canPop()
          ? context.pop()
          : context.go(RouteNames.contactCommunityTeam),
    ),
  );
}

void _prefillOnce(ProfileUser? profile) {
  if (_prefilled) return;
  _prefilled = true;

  final name = (profile?.fullName ?? profile?.displayName ?? '').trim();
  final email = (profile?.email ?? '').trim().isNotEmpty
      ? profile!.email.trim()
      : (Supabase.instance.client.auth.currentUser?.email ?? '').trim();

  if (name.isNotEmpty) _nameController.text = name;
  if (email.isNotEmpty) _emailController.text = email;

  // If profile load finishes after first frame, refresh so fields show text.
  if (mounted) setState(() {});
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

  Future<void> _submit() async {
  if (isSubmitting) return;
  if (!(_formKey.currentState?.validate() ?? false)) return;
  if (selectedSubject == null || selectedSubject!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          translate(context, 'contactCommunity.selectPlaceholder'),
        ),
      ),
    );
    return;
  }

  setState(() => isSubmitting = true);
  try {
    final online =
        await NetworkConnectivityService.instance.checkInternetConnection();
    if (!mounted) return;
    if (!online) {
      _showContactFailure();
      return;
    }

    final ok = await SupportService().sendContactMessage(
      subject: selectedSubject!,
      message: _messageController.text.trim(),
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    if (!mounted) return;
    ok ? _showContactSuccess() : _showContactFailure();
  } catch (_) {
    if (!mounted) return;
    _showContactFailure();
  } finally {
    if (mounted) setState(() => isSubmitting = false);
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
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.blackBase,
            ),
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
                      children: [_buildContactForm()],
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
          SizedBox(height: AppSpacing.v10),
          _buildHeader(),
          SizedBox(height: AppSpacing.v22),
          _buildSubjectField(subjects),
          SizedBox(height: AppSpacing.v20),
          _buildMessageField(),
          SizedBox(height: AppSpacing.v20),
          _buildNameField(),
          SizedBox(height: AppSpacing.v20),
          _buildEmailField(),
          SizedBox(height: AppSpacing.v20),
          _buildSendButton(),
          SizedBox(height: AppSpacing.v6),
          _buildCancelButton(),
          SizedBox(height: AppSpacing.v4),
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
          style: AppTextStyles.titleMedium.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSubjectField(List<String> subjects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(context, 'contactCommunity.subject'),
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        ),
        SizedBox(height: AppSpacing.v10),
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
                    selectedSubject ??
                        translate(
                          context,
                          'contactCommunity.selectPlaceholder',
                        ),
                    style: selectedSubject == null
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

  Widget _buildMessageField() {
    return Container(
      key: _messageFieldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(context, 'contactCommunity.message'),
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.blackBase,
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          TextFormField(
            focusNode: _messageFocusNode,
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: translate(context, 'contactCommunity.messageHint'),
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.blackBase)
                  .copyWith(color: AppColors.neutral300),
              filled: true,
              fillColor: AppColors.whiteBase.withOpacity(0.9),
              contentPadding: AppSpacing.symmetric(
                horizontal: AppSpacing.h16,
                vertical: AppSpacing.v12,
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
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      key: _nameFieldKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate(context, 'contactCommunity.fullName'),
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.blackBase,
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          TextFormField(
            focusNode: _nameFocusNode,
            controller: _nameController,
            decoration: InputDecoration(
              hintText: translate(context, 'contactCommunity.nameHint'),
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.blackBase)
                  .copyWith(color: AppColors.neutral300),
              filled: true,
              fillColor: AppColors.whiteBase.withOpacity(0.9),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.h16,
                vertical: AppSpacing.v16,
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
          Text(
            translate(context, 'contactCommunity.email'),
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.blackBase,
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          TextFormField(
            focusNode: _emailFocusNode,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: translate(context, 'contactCommunity.emailHint'),
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.blackBase)
                  .copyWith(color: AppColors.neutral300),
              filled: true,
              fillColor: AppColors.whiteBase.withOpacity(0.9),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.h16,
                vertical: AppSpacing.v16,
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
      margin: AppSpacing.horizontal(AppSpacing.h20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GradientButton(
  height: 50.h,
  textStyle: AppTextStyles.titleMedium.copyWith(
    color: AppColors.whiteBase,
  ),
  text: translate(context, 'contactCommunity.sendMessage'),
  isLoading: isSubmitting,
  onTap: isSubmitting ? () {} : _submit,
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
