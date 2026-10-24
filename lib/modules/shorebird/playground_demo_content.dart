import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

/// The content shown in the "Live demo" banner of the Shorebird Playground.
///
/// This is the file to edit during the live demo. It is plain Dart, so a
/// `shorebird patch` can ship a change here to an already-installed app
/// without a Play Store release.
///
/// Demo flow:
///   1. Install the release build and open Profile > Shorebird Playground.
///   2. Change the values below (and bump [revision]).
///   3. `shorebird patch android --release-version=<version shown in the app>`
///   4. In the app tap "Check for update", then "Download update",
///      then "Close app to apply" and reopen it. The banner now shows the
///      patched content.
abstract class PlaygroundDemoContent {
  PlaygroundDemoContent._();

  /// Shown large on the banner.
  static const String headline = 'Shipped with the Play Store build';

  /// Shown under the headline.
  static const String message =
      'This text lives in the app bundle. Patch it over the air.';

  /// A big visual cue that is easy to spot from the back of a room.
  static const String emoji = '📦';

  /// Banner colour. Change it to make the patch obvious on a projector.
  static const Color accent = AppColors.primary500;

  /// Bump this each time you patch so the audience can count updates.
  static const int revision = 0;
}
