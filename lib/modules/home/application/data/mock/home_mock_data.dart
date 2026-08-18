import 'package:flutter_knp_mobile_app_v2/modules/home/domain/entities/event_entity.dart';

class HomeMockData {
  HomeMockData._();

  static final List<EventEntity> events = [
    // --------------------------------------------------
    // 1. UPCOMING + OFFLINE + FREE + OPEN TO ALL
    // THIS WEEK + FLUTTER + BEGINNER FRIENDLY
    // --------------------------------------------------
    EventEntity(
      id: 'event_001',
      category: 'Technology',
      title: 'Flutter Kanpur Launch Event',
      description:
          'Join the Flutter Kanpur community for an exciting launch event with talks, networking, and discussions around Flutter and mobile development.',
      shortDescription: 'Flutter Kanpur community launch event.',
      cover: 'assets/launch_event.png',
      fromTime: DateTime(2026, 8, 15, 16, 0),
      toTime: DateTime(2026, 8, 15, 18, 0),
      type: 'upcoming',
      mode: 'Offline',
      isFree: true,
      isOpenToAll: true,
      interests: ['Flutter', 'Beginner Friendly'],
      speakerName: 'Flutter Kanpur Team',
      speakerImage: null,
      speakerIntro: 'Flutter and mobile development community.',
      speakerLinkedin: null,
      speakerTwitter: null,
      hostName: 'Flutter Kanpur',
      hostImage: null,
    ),

    // --------------------------------------------------
    // 2. UPCOMING + ONLINE + FREE
    // THIS MONTH + UI / UX + DESIGN
    // --------------------------------------------------
    EventEntity(
      id: 'event_002',
      category: 'Design',
      title: 'Design Systems for Flutter',
      description:
          'Learn how to build scalable design systems and maintain consistent UI across Flutter applications.',
      shortDescription: 'Build scalable UI and design systems.',
      cover: 'assets/fk_card.png',
      fromTime: DateTime(2026, 8, 20, 18, 0),
      toTime: DateTime(2026, 8, 20, 20, 0),
      type: 'upcoming',
      mode: 'Online',
      isFree: true,
      isOpenToAll: true,
      interests: ['UI / UX', 'Design'],
      speakerName: 'Flutter Kanpur Design Team',
      speakerImage: null,
      speakerIntro: 'UI/UX designers and Flutter developers.',
      speakerLinkedin: null,
      speakerTwitter: null,
      hostName: 'Flutter Kanpur',
      hostImage: null,
    ),

    // --------------------------------------------------
    // 3. UPCOMING + OFFLINE + PAID
    // THIS MONTH + ADVANCED + FLUTTER
    // --------------------------------------------------
    EventEntity(
      id: 'event_003',
      category: 'Technology',
      title: 'Advanced Flutter Architecture',
      description:
          'A deep dive into scalable Flutter architecture, state management, dependency injection, and clean code practices.',
      shortDescription: 'Advanced Flutter architecture workshop.',
      cover: 'assets/launch_event.png',
      fromTime: DateTime(2026, 8, 25, 11, 0),
      toTime: DateTime(2026, 8, 25, 14, 0),
      type: 'upcoming',
      mode: 'Offline',
      isFree: false,
      isOpenToAll: false,
      interests: ['Flutter', 'Advanced'],
      speakerName: 'Flutter Kanpur Team',
      speakerImage: null,
      speakerIntro: 'Flutter developers and community contributors.',
      speakerLinkedin: null,
      speakerTwitter: null,
      hostName: 'Flutter Kanpur',
      hostImage: null,
    ),

    // --------------------------------------------------
    // 4. LIVE + ONLINE + FREE + OPEN TO ALL
    // THIS MONTH + FLUTTER + UI / UX
    // --------------------------------------------------
    EventEntity(
      id: 'event_004',
      category: 'Technology',
      title: 'Flutter Live Coding Session',
      description:
          'Join a live coding session where we build a Flutter application from scratch and discuss practical development techniques.',
      shortDescription: 'Live Flutter coding session.',
      cover: 'assets/fk_card.png',
      fromTime: DateTime(2026, 8, 10, 9, 0),
      toTime: DateTime(2026, 8, 10, 13, 0),
      type: 'upcoming',
      mode: 'Online',
      isFree: true,
      isOpenToAll: true,
      interests: ['Flutter', 'UI / UX'],
      speakerName: 'Flutter Kanpur Team',
      speakerImage: null,
      speakerIntro: 'Flutter community developers.',
      speakerLinkedin: null,
      speakerTwitter: null,
      hostName: 'Flutter Kanpur',
      hostImage: null,
    ),

    // --------------------------------------------------
    // 5. PAST + OFFLINE + FREE
    // PAST + DESIGN + BEGINNER FRIENDLY
    // --------------------------------------------------
    EventEntity(
      id: 'event_005',
      category: 'Design',
      title: 'UI / UX Fundamentals Workshop',
      description:
          'An introductory workshop covering UI/UX fundamentals, design principles, and practical interface design.',
      shortDescription: 'UI/UX fundamentals for beginners.',
      cover: 'assets/launch_event.png',
      fromTime: DateTime(2026, 7, 12, 16, 0),
      toTime: DateTime(2026, 7, 12, 18, 0),
      type: 'past',
      mode: 'Offline',
      isFree: true,
      isOpenToAll: true,
      interests: ['UI / UX', 'Design', 'Beginner Friendly'],
      speakerName: 'Flutter Kanpur Design Team',
      speakerImage: null,
      speakerIntro: 'Designers and community members.',
      speakerLinkedin: null,
      speakerTwitter: null,
      hostName: 'Flutter Kanpur',
      hostImage: null,
    ),

    // --------------------------------------------------
    // 6. PAST + ONLINE + PAID
    // ADVANCED + FLUTTER
    // --------------------------------------------------
    EventEntity(
      id: 'event_006',
      category: 'Technology',
      title: 'Advanced Flutter State Management',
      description:
          'A technical session covering advanced state management patterns and architectural decisions in production Flutter applications.',
      shortDescription: 'Advanced state management session.',
      cover: 'assets/fk_card.png',
      fromTime: DateTime(2026, 7, 20, 17, 0),
      toTime: DateTime(2026, 7, 20, 19, 0),
      type: 'past',
      mode: 'Online',
      isFree: false,
      isOpenToAll: false,
      interests: ['Flutter', 'Advanced'],
      speakerName: 'Flutter Kanpur Team',
      speakerImage: null,
      speakerIntro: 'Experienced Flutter developers.',
      speakerLinkedin: null,
      speakerTwitter: null,
      hostName: 'Flutter Kanpur',
      hostImage: null,
    ),
  ];
}
