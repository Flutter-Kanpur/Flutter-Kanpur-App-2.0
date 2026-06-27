import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_version_plus/model/version_status.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // Assuming you have an AppColors file, otherwise I will use standard colors

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
      debugPrint('App Update Status: ${status?.localVersion} -> ${status?.storeVersion}');
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
            backgroundColor: const Color(0xFF0F1C25), // Match app theme
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Color(0xFF2A3C4D)),
            ),
            title: const Text(
              'Update Available',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A new version (${status.storeVersion}) is available. Please update the app to enjoy the latest features and bug fixes.',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current Version: ${status.localVersion}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Later', style: TextStyle(color: Colors.white54)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
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
      url = "https://play.google.com/store/search?q=flutter%20kanpur&c=apps&hl=en";
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
