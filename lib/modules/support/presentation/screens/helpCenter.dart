import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/search_bar.dart';
import 'package:flutter_knp_mobile_app_v2/modules/support/presentation/widgets/categoryCard.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  int expandedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<Map<String, String>> _getFaqs(BuildContext context) {
    return [
      {
        'q': translate(context, 'helpCenter.faq1.q'),
        'a': translate(context, 'helpCenter.faq1.a'),
      },
      {
        'q': translate(context, 'helpCenter.faq2.q'),
        'a': translate(context, 'helpCenter.faq2.a'),
      },
      {
        'q': translate(context, 'helpCenter.faq3.q'),
        'a': translate(context, 'helpCenter.faq3.a'),
      },
    ];
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
            translate(context, "helpCenter.title"),
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.v10),

              CommonSearchBar(
                controller: _searchController,
                hintText: 'Search for events...',
                onChanged: (v) => setState(() {
                  _query = v.trim();
                  expandedIndex = -1;
                }),
                onMicTap: () {
                  // TODO: add voice input handling
                },
              ),

              SizedBox(height: AppSpacing.v22),

              // 🔹 FAQ
              ..._buildFaqItems(),

              SizedBox(height: AppSpacing.v12),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.h10),
                child: Text(
                  translate(context, 'helpCenter.quickHelpTitle'),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary500,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.v16),

              SizedBox(
                height: 120.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: AppSpacing.horizontal(AppSpacing.h20),
                  children: [
                    CategoryCard(
                      title: translate(context, 'helpCenter.category1.title'),
                      description: translate(
                        context,
                        'helpCenter.category1.desc',
                      ),
                    ),
                    SizedBox(width: AppSpacing.h12),
                    CategoryCard(
                      title: translate(context, 'helpCenter.category2.title'),
                      description: translate(
                        context,
                        'helpCenter.category2.desc',
                      ),
                    ),
                    SizedBox(width: AppSpacing.h12),
                    CategoryCard(
                      title: translate(context, 'helpCenter.category3.title'),
                      description: translate(
                        context,
                        'helpCenter.category3.desc',
                      ),
                    ),
                    SizedBox(width: AppSpacing.h12),
                    CategoryCard(
                      title: translate(context, 'helpCenter.category4.title'),
                      description: translate(
                        context,
                        'helpCenter.category4.desc',
                      ),
                    ),
                    SizedBox(width: AppSpacing.h12),
                    CategoryCard(
                      title: translate(context, 'helpCenter.category5.title'),
                      description: translate(
                        context,
                        'helpCenter.category5.desc',
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.v22),

              Center(
                child: Column(
                  children: [
                    Text(
                      translate(context, 'helpCenter.stillNeedHelp'),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.blackBase,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppSpacing.v12),
                    Text(
                      translate(context, 'helpCenter.cantFind'),
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.blackBase)
                          .apply(color: AppColors.neutral300),
                    ),
                    SizedBox(height: AppSpacing.v16),
                    GradientButton(
                      height: 45.h,
                      width: 230.w,
                      textStyle: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.whiteBase,
                      ),
                      text: translate(context, 'helpCenter.contactButton'),
                      onTap: () {
                        context.push('/profile/contact-community-team');
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.v22),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFaqItems() {
    final query = _query.toLowerCase();

    // If empty, show original order
    List<Map<String, String>> source = List.from(_getFaqs(context));

    if (query.isNotEmpty) {
      final matching = <Map<String, String>>[];
      final others = <Map<String, String>>[];

      for (final f in source) {
        final q = f['q']!.toLowerCase();
        final a = f['a']!.toLowerCase();
        if (q.contains(query) || a.contains(query)) {
          matching.add(f);
        } else {
          others.add(f);
        }
      }

      // sort matching so that question matches come before answer-only matches
      matching.sort((x, y) {
        final xQ = x['q']!.toLowerCase().contains(query);
        final yQ = y['q']!.toLowerCase().contains(query);
        if (xQ == yQ) return 0;
        return xQ ? -1 : 1;
      });

      source = [...matching, ...others];
    }

    return List.generate(source.length, (index) {
      final f = source[index];
      final isExpanded = expandedIndex == index;

      return Container(
        margin: EdgeInsets.only(bottom: AppSpacing.v12),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all03,
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                f['q']!,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.blackBase,
                ),
              ),
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? -1 : index;
                });
              },
            ),
            if (isExpanded)
              Container(
                width: double.infinity,
                padding: AppSpacing.only(
                  left: AppSpacing.h16,
                  top: 0,
                  right: AppSpacing.h16,
                  bottom: AppSpacing.v16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSpacing.h6,
                      height: 40.h,
                      margin: EdgeInsets.only(right: AppSpacing.h10),
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: AppRadius.all01,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        f['a']!,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.neutral400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
