import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerCard extends ConsumerWidget {
  final String answerId;
  final String authorName;
  final String? authorPhotoUrl;
  final String body;
  final String createdAt;
  final int likeCount;
  final bool isOwnAnswer;
  final VoidCallback? onDelete;
  final VoidCallback? onLike;

  const AnswerCard({
    super.key,
    required this.answerId,
    required this.authorName,
    required this.body,
    required this.createdAt,
    required this.likeCount,
    this.authorPhotoUrl,
    this.isOwnAnswer = false,
    this.onDelete,
    this.onLike,
  });

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage: authorPhotoUrl != null
                    ? NetworkImage(authorPhotoUrl!)
                    : null,
                child: authorPhotoUrl == null
                    ? Text(
                  _getInitials(authorName),
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      createdAt,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwnAnswer)
                PopupMenuButton(
                  itemBuilder: (context) => [
                    if (onDelete != null)
                      PopupMenuItem(
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: onDelete,
                      ),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
            ],
          ),
          SizedBox(height: 12.h),

          // Answer Body
          Text(
            body,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),

          // Bottom Stats
          Row(
            children: [
              // Like Button
              TextButton.icon(
                onPressed: onLike,
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                label: Text('$likeCount'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
