import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Outbound URLs the app links to.
///
/// Overridable at build time via `--dart-define` so the community team can
/// rotate an invite without shipping a new binary.
class ExternalLinks {
  const ExternalLinks._();

  static const discordInvite = String.fromEnvironment(
    'FK_DISCORD_INVITE',
    defaultValue: 'https://discord.com/invite/pD6WsK6k5E',
  );

  static const github = 'https://github.com/Flutter-Kanpur';
  static const website = 'https://flutterkanpur.dev';
}

/// Opens [url] in an external app / browser.
///
/// Returns false when the platform refuses to handle it, so callers can show a
/// message instead of the tap silently doing nothing.
Future<bool> openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

/// [openExternalUrl] plus a snackbar when the link can't be opened.
Future<void> openExternalUrlOrNotify(
  BuildContext context,
  String url, {
  String failureMessage = "Couldn't open the link.",
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final opened = await openExternalUrl(url);
  if (opened) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failureMessage)));
}

/// Opens [url] in an in-app browser view (Chrome Custom Tabs on Android,
/// SFSafariViewController on iOS) instead of switching to a separate browser
/// app - for links that should keep the user inside the app.
///
/// Returns false when the platform refuses to handle it, so callers can show a
/// message instead of the tap silently doing nothing.
Future<bool> openInAppUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  try {
    return await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  } catch (_) {
    return false;
  }
}

/// [openInAppUrl] plus a snackbar when the link can't be opened.
Future<void> openInAppUrlOrNotify(
  BuildContext context,
  String url, {
  String failureMessage = "Couldn't open the link.",
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final opened = await openInAppUrl(url);
  if (opened) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(failureMessage)));
}
