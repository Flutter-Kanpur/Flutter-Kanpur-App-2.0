import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // Assuming you have an AppColors file, otherwise I will use standard colors
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();

  factory AppUpdateService() {
    return _instance;
  }

  AppUpdateService._internal();

  /// Checks for app update and shows a dialog if an update is available.
  Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(
      // iOS app store region (optional, specific to your app's region)
      // androidId: 'com.flutterkanpur.community', // Automatically detected
      // iOSId: 'com.flutterkanpur.community', // Automatically detected
    );

    try {
      final status = await newVersion.getVersionStatus();
      debugPrint(
        'App Update Status: ${status?.localVersion} -> ${status?.storeVersion}',
      );
      if (status != null && status.canUpdate) {
        if (context.mounted) {
          _showUpdateDialog(context, status);
        }
      }
    } catch (e) {
      debugPrint('Error checking for update: $e');
    }
  }

  void _showUpdateDialog(BuildContext context, VersionStatus status) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to choose an action
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button closure
          child: AlertDialog(
            backgroundColor: AppColors.blackBase, // Match app theme
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.all04,
              side: const BorderSide(color: AppBorders.blue),
            ),
            title: Text(
              'Update Available',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.whiteBase,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version (${status.storeVersion}) is available. Please update the app to enjoy the latest features and bug fixes.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.whiteBase.withValues(alpha: 0.70),
                  ),
                ),
                SizedBox(height: AppSpacing.v8),
                Text(
                  'Current Version: ${status.localVersion}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.whiteBase.withValues(alpha: 0.38),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Later',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.whiteBase.withValues(alpha: 0.54),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  foregroundColor: AppColors.whiteBase,
                ),
                child: const Text('Update Now'),
                onPressed: () {
                  _launchStore();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchStore() async {
    final String url;
    if (Platform.isAndroid) {
      url =
          "https://play.google.com/store/search?q=flutter%20kanpur&c=apps&hl=en";
    } else if (Platform.isIOS) {
      url = "https://apps.apple.com/";
    } else {
      return;
    }

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch store url: $url');
    }
  }
}
