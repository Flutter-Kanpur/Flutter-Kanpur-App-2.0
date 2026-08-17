import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

/// Green "Confused about where to start?" card at the top of Community.
///
/// Previously this was one flat SVG with the heading, avatars and button all
/// baked into the image. Nothing could be restyled, the text did not scale or
/// localise, and the "Ask a question" button was not a button - a tap anywhere
/// on the artwork navigated. It is now composed of real widgets, so the button
/// is its own tap target and the avatars can show actual members.
class CommunityAskBanner extends StatelessWidget {
  const CommunityAskBanner({
    super.key,
    required this.onAskQuestion,
    this.memberPhotoUrls = const [],
    this.title = 'Confused about where to start?',
    this.body =
        'Ask questions, share ideas, or help others by starting a '
        'conversation with the community.',
    this.buttonLabel = 'Ask a question',
  });

  final VoidCallback onAskQuestion;

  /// Up to four member photos, rendered as an overlapping stack.
  final List<String> memberPhotoUrls;

  final String title;
  final String body;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all(AppSpacing.h20),
      decoration: BoxDecoration(
        borderRadius: AppRadius.all06,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.contributorGreenBackground,
            AppColors.success800,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.whiteBase,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
              if (memberPhotoUrls.isNotEmpty) ...[
                SizedBox(width: AppSpacing.h12),
                _AvatarStack(photoUrls: memberPhotoUrls),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.v10),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.whiteBase.withValues(alpha: 0.92),
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.v16),
          // Its own tap target - the card itself is deliberately not tappable.
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onAskQuestion,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.whiteBase,
                foregroundColor: AppColors.neutral950,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h20,
                  vertical: AppSpacing.v12,
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.all09),
              ),
              child: Text(
                buttonLabel,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.neutral950,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Overlapping circular member photos, newest first.
class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.photoUrls});

  final List<String> photoUrls;

  static const _size = 30.0;
  static const _overlap = 10.0;

  @override
  Widget build(BuildContext context) {
    final shown = photoUrls.take(4).toList();
    final width = _size + (shown.length - 1) * (_size - _overlap);

    return SizedBox(
      height: _size,
      width: width,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * (_size - _overlap),
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.whiteBase, width: 1.5),
                  color: AppColors.primary100,
                  image: DecorationImage(
                    image: NetworkImage(shown[i]),
                    fit: BoxFit.cover,
                    // A broken photo leaves the plain circle rather than
                    // throwing during paint.
                    onError: (_, _) {},
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
