import 'package:go_router/go_router.dart';
import 'route_names.dart';

class NavigationHelper {
  static Future<void> goToAskQuestion(context) {
    return context.push(RouteNames.communityAskQuestion);
  }

  static Future<void> goToQuestionList(context) {
    return context.push(RouteNames.communityDiscussions);
  }

  static Future<void> goToQuestionDetail(context, String questionId) {
    return context.push(
      RouteNames.communityDiscussions.replaceFirst(':id', questionId),
    );
  }

  static Future<void> goToHome(context) {
    return context.go(RouteNames.home);
  }

  static Future<void> goToCommunity(context) {
    return context.push(RouteNames.community);
  }

  static Future<void> goToProfile(context) {
    return context.push(RouteNames.profile);
  }

  static void back(context) {
    context.pop();
  }
}
