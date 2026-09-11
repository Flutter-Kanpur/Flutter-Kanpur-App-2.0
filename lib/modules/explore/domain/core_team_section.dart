import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';

/// Section header from `core_team_sections` (admin-managed).
class CoreTeamSectionInfo {
  const CoreTeamSectionInfo({
    required this.id,
    required this.slug,
    required this.title,
    this.sortOrder = 0,
  });

  final String id;
  final String slug;
  final String title;
  final int sortOrder;

  bool get isOrganisorsStyle => slug.toLowerCase().contains('organi');

  factory CoreTeamSectionInfo.fromMap(Map<String, dynamic> map) {
    return CoreTeamSectionInfo(
      id: (map['id'] ?? '').toString(),
      slug: (map['slug'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// One section bucket for the Core Team screen.
class CoreTeamSectionBucket {
  const CoreTeamSectionBucket({
    required this.section,
    required this.members,
  });

  final CoreTeamSectionInfo section;
  final List<CoreTeamMember> members;
}

/// Groups members by dynamic section headers from Supabase.
class CoreTeamGrouping {
  CoreTeamGrouping._();

  static const _otherId = '__other__';

  /// Ordered buckets: known sections first (by [sortOrder]), then unmatched.
  static List<CoreTeamSectionBucket> groupBySections({
    required List<CoreTeamSectionInfo> sections,
    required List<CoreTeamMember> members,
  }) {
    final ordered = List<CoreTeamSectionInfo>.from(sections)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final byId = <String, List<CoreTeamMember>>{
      for (final s in ordered) s.id: <CoreTeamMember>[],
    };
    final bySlug = <String, String>{
      for (final s in ordered) s.slug.toLowerCase(): s.id,
    };
    final other = <CoreTeamMember>[];

    for (final member in members) {
      final id = member.sectionId;
      if (id != null && byId.containsKey(id)) {
        byId[id]!.add(member);
        continue;
      }

      // Fallback: denormalized team_section / joined section slug.
      final slug =
          (member.sectionSlug ?? member.teamSection)?.toLowerCase();
      final fromSlug = slug == null ? null : bySlug[slug];
      if (fromSlug != null) {
        byId[fromSlug]!.add(member);
      } else {
        other.add(member);
      }
    }

    final buckets = <CoreTeamSectionBucket>[
      for (final s in ordered)
        CoreTeamSectionBucket(
          section: s,
          members: sortLeadsFirst(byId[s.id] ?? const []),
        ),
    ];

    if (other.isNotEmpty) {
      buckets.add(
        CoreTeamSectionBucket(
          section: const CoreTeamSectionInfo(
            id: _otherId,
            slug: 'other',
            title: 'Other',
            sortOrder: 9999,
          ),
          members: sortLeadsFirst(other),
        ),
      );
    }

    return buckets;
  }

  static List<CoreTeamMember> sortLeadsFirst(List<CoreTeamMember> members) {
    final list = List<CoreTeamMember>.from(members);
    list.sort((a, b) {
      if (a.isLead && !b.isLead) return -1;
      if (!a.isLead && b.isLead) return 1;
      return a.name.compareTo(b.name);
    });
    return list;
  }
}

extension CoreTeamMemberX on CoreTeamMember {
  bool get isLead => role.toLowerCase().contains('lead');

  /// Short role label for cards. Organisors-style sections use organiser wording.
  String roleLabel({required bool isOrganisorsSection}) {
    final normalized = role.trim().toLowerCase();

    if (isOrganisorsSection) {
      if (normalized.contains('co') && normalized.contains('organi')) {
        return 'Co Organisor';
      }
      if (normalized.contains('organi')) return 'Organisor';
      return 'Organisor';
    }

    if (normalized.contains('mobile lead') ||
        normalized.contains('web lead') ||
        normalized.contains('design lead')) {
      return 'Lead';
    }
    if (normalized.contains('developer') || normalized.contains('member')) {
      return 'Member';
    }

    return role;
  }

  Color roleColor({required bool isOrganisorsSection}) {
    final label = roleLabel(isOrganisorsSection: isOrganisorsSection);
    if (label == 'Member') return AppColors.primary500;
    if (label == 'Organisor' || label == 'Co Organisor') {
      return AppColors.green;
    }
    return AppColors.green;
  }
}
