import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String category;
  final String title;
  final String description;
  final String? shortDescription;
  final String? cover;
  final DateTime? fromTime;
  final DateTime? toTime;
  final String type; // 'past' or 'upcoming'
  final String? speakerName;
  final String? speakerImage;
  final String? speakerIntro;
  final String? speakerLinkedin;
  final String? speakerTwitter;
  final String? hostName;
  final String? hostImage;

  const EventEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.shortDescription,
    this.cover,
    this.fromTime,
    this.toTime,
    required this.type,
    this.speakerName,
    this.speakerImage,
    this.speakerIntro,
    this.speakerLinkedin,
    this.speakerTwitter,
    this.hostName,
    this.hostImage,
  });

  bool get isUpcoming {
    if (fromTime == null) return true;
    final now = DateTime.now();
    return fromTime!.isAfter(now);
  }

  bool get isPast {
    if (toTime == null) {
      if (fromTime == null) return false;
      return fromTime!.isBefore(DateTime.now());
    }
    return toTime!.isBefore(DateTime.now());
  }

  bool get isComingSoon => fromTime == null;

  // Check if event is currently running (between from_time and to_time)
  bool get isRunning {
    if (fromTime == null || toTime == null) return false;
    final now = DateTime.now();
    return now.isAfter(fromTime!) && now.isBefore(toTime!);
  }

  // Check if registration is closing soon (from_time within 3 days)
  bool get isRegistrationClosing {
    if (fromTime == null) return false;
    final now = DateTime.now();
    final daysUntilEvent = fromTime!.difference(now).inDays;
    return daysUntilEvent >= 0 && daysUntilEvent <= 3 && !isRunning;
  }

  // Get event status data (label and color)
  Map<String, dynamic> get eventStatus {
    if (isRunning) {
      return {
        'label': 'Event Running',
        'color': 0xFFEF4444, // Red
        'bgColor': 0xFFFEE2E2, // Light red background
      };
    } else if (isRegistrationClosing) {
      return {
        'label': 'Registration Closing',
        'color': 0xFFF59E0B, // Amber/Orange
        'bgColor': 0xFFFEF3C7, // Light amber background
      };
    } else if (isPast) {
      return {
        'label': 'Past',
        'color': 0xFF6B7280, // Gray
        'bgColor': 0xFFF3F4F6, // Light gray background
      };
    } else {
      return {
        'label': 'Upcoming',
        'color': 0xFF10B981, // Green
        'bgColor': 0xFFD1FAE5, // Light green background
      };
    }
  }

  String get formattedDate {
    if (fromTime == null) return 'Coming Soon';
    return '${fromTime!.day} ${_getMonthName(fromTime!.month)} ${fromTime!.year}';
  }

  String get formattedTime {
    if (fromTime == null) return 'TBD';
    return '${fromTime!.hour.toString().padLeft(2, '0')}:${fromTime!.minute.toString().padLeft(2, '0')}';
  }

  // Format: "Sun, 7 Apr"
  String get formattedDateShort {
    if (fromTime == null) return 'Coming Soon';
    return '${_getDayName(fromTime!.weekday)}, ${fromTime!.day} ${_getMonthNameShort(fromTime!.month)}';
  }

  // Format: "4:00 PM"
  String get formattedTime12Hour {
    if (fromTime == null) return 'TBD';
    final hour = fromTime!.hour;
    final minute = fromTime!.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${hour12}:${minute.toString().padLeft(2, '0')} $period';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getMonthNameShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  // Converts Google Drive shareable URL to a direct image URL
  // Input:  https://drive.google.com/file/d/FILE_ID/view?usp=sharing
  // Output: https://lh3.googleusercontent.com/d/FILE_ID
  String? get coverImageUrl {
    if (cover == null || cover!.isEmpty) return null;

    // Already a direct / non-Drive URL — return as-is
    if (!cover!.contains('drive.google.com')) return cover;

    // Extract file ID from the shareable link pattern
    final regex = RegExp(r'/d/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(cover!);
    if (match != null) {
      final fileId = match.group(1);
      return 'https://lh3.googleusercontent.com/d/$fileId';
    }

    return cover;
  }

  @override
  List<Object?> get props => [id, category, title, description, shortDescription, cover, fromTime, toTime, type, speakerName, speakerImage, speakerIntro, speakerLinkedin, speakerTwitter, hostName, hostImage];
} 