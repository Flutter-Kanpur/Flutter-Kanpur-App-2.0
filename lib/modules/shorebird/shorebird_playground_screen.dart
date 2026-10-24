import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/shorebird/playground_demo_content.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

/// A live-demo screen for Shorebird code push.
///
/// Shows what the updater sees (release version, current patch, downloaded
/// patch), lets the presenter check for and download a patch, and renders the
/// [PlaygroundDemoContent] banner that a patch can change.
class ShorebirdPlaygroundScreen extends StatefulWidget {
  const ShorebirdPlaygroundScreen({super.key});

  @override
  State<ShorebirdPlaygroundScreen> createState() =>
      _ShorebirdPlaygroundScreenState();
}

class _ShorebirdPlaygroundScreenState extends State<ShorebirdPlaygroundScreen> {
  final ShorebirdUpdater _updater = ShorebirdUpdater();

  PackageInfo? _packageInfo;
  Patch? _currentPatch;
  Patch? _nextPatch;
  UpdateStatus? _status;
  bool _busy = false;
  final List<_LogEntry> _log = [];

  bool get _available => _updater.isAvailable;

  String get _releaseVersion {
    final info = _packageInfo;
    if (info == null) return '…';
    return '${info.version}+${info.buildNumber}';
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _addLog(String message) {
    if (!mounted) return;
    setState(() => _log.insert(0, _LogEntry(DateTime.now(), message)));
  }

  Future<void> _refresh() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = await _updater.readCurrentPatch();
      final next = await _updater.readNextPatch();
      if (!mounted) return;
      setState(() {
        _packageInfo = info;
        _currentPatch = current;
        _nextPatch = next;
      });
    } on ReadPatchException catch (e) {
      _addLog('Could not read patch state: ${e.message}');
    }
  }

  Future<void> _checkForUpdate() async {
    if (!_available) {
      _addLog('Updater unavailable: this is not a Shorebird release build.');
      return;
    }
    setState(() => _busy = true);
    _addLog('Checking for an update…');
    try {
      final status = await _updater.checkForUpdate();
      if (!mounted) return;
      setState(() => _status = status);
      _addLog(switch (status) {
        UpdateStatus.upToDate => 'Up to date. No new patch.',
        UpdateStatus.outdated => 'A new patch is available. Tap Download.',
        UpdateStatus.restartRequired =>
          'Patch already downloaded. Restart the app to apply it.',
        UpdateStatus.unavailable => 'Updater unavailable.',
      });
      await _refresh();
    } catch (e) {
      _addLog('Check failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _downloadUpdate() async {
    if (!_available) {
      _addLog('Updater unavailable: this is not a Shorebird release build.');
      return;
    }
    setState(() => _busy = true);
    _addLog('Downloading patch…');
    try {
      await _updater.update();
      if (!mounted) return;
      setState(() => _status = UpdateStatus.restartRequired);
      _addLog('Patch installed. Close and reopen the app to run it.');
      await _refresh();
    } on UpdateException catch (e) {
      _addLog('Update failed (${e.reason.name}): ${e.message}');
    } catch (e) {
      _addLog('Update failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'Shorebird Playground',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.h20,
                AppSpacing.v8,
                AppSpacing.h20,
                AppSpacing.v22,
              ),
              children: [
                _DemoBanner(patchNumber: _currentPatch?.number),
                SizedBox(height: AppSpacing.v16),
                _statusCard(),
                SizedBox(height: AppSpacing.v16),
                FkPrimaryButton(
                  label: 'Check for update',
                  icon: Icons.refresh_rounded,
                  isLoading: _busy,
                  onPressed: _busy ? null : _checkForUpdate,
                ),
                SizedBox(height: AppSpacing.v10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _busy ? null : _downloadUpdate,
                        icon: const Icon(Icons.download_rounded),
                        label: const Text('Download update'),
                      ),
                    ),
                    SizedBox(width: AppSpacing.h10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: SystemNavigator.pop,
                        icon: const Icon(Icons.power_settings_new_rounded),
                        label: const Text('Close app'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.v16),
                _logCard(),
                SizedBox(height: AppSpacing.v16),
                _cheatSheetCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusCard() {
    final patch = _currentPatch;
    final next = _nextPatch;
    final downloadedNew =
        next != null && (patch == null || next.number != patch.number);
    return _Card(
      title: 'Updater status',
      trailing: _StatusChip(available: _available, status: _status),
      child: Column(
        children: [
          _InfoRow(label: 'Release version', value: _releaseVersion),
          _InfoRow(
            label: 'Running patch',
            value: patch == null ? 'None (base release)' : '#${patch.number}',
          ),
          _InfoRow(
            label: 'Downloaded patch',
            value: next == null
                ? 'None'
                : '#${next.number}${downloadedNew ? '  (restart to apply)' : ''}',
          ),
          if (!_available)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.v8),
              child: Text(
                'Not a Shorebird release build, so patches cannot be '
                'received. Install the build made with `shorebird release` '
                '(or `shorebird preview`).',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warning600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _logCard() {
    return _Card(
      title: 'Event log',
      trailing: _log.isEmpty
          ? null
          : TextButton(
              onPressed: () => setState(_log.clear),
              child: const Text('Clear'),
            ),
      child: _log.isEmpty
          ? Text(
              'Tap "Check for update" to start.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.neutral500,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in _log)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.v6),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${_formatTime(entry.time)}  ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                          TextSpan(
                            text: entry.message,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _cheatSheetCard() {
    final patchCommand =
        'shorebird patch android --release-version=$_releaseVersion';
    return _Card(
      title: 'Demo cheat sheet',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommandRow(
            step: '1',
            label: 'Release (once)',
            command: 'shorebird release android --flutter-version=3.47.1',
            onCopy: _copy,
          ),
          _CommandRow(
            step: '2',
            label: 'Edit playground_demo_content.dart',
            command: 'lib/modules/shorebird/playground_demo_content.dart',
            onCopy: _copy,
          ),
          _CommandRow(
            step: '3',
            label: 'Patch',
            command: patchCommand,
            onCopy: _copy,
          ),
          _CommandRow(
            step: '4',
            label: 'On the phone',
            command: 'Check > Download > Close app > Reopen',
            onCopy: _copy,
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }
}

class _LogEntry {
  const _LogEntry(this.time, this.message);
  final DateTime time;
  final String message;
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner({required this.patchNumber});

  final int? patchNumber;

  @override
  Widget build(BuildContext context) {
    final accent = PlaygroundDemoContent.accent;
    return Container(
      padding: EdgeInsets.all(AppSpacing.h20),
      decoration: BoxDecoration(
        borderRadius: AppRadius.all04,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, accent.withValues(alpha: 0.72)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v6,
            children: [
              _pill('LIVE DEMO · revision ${PlaygroundDemoContent.revision}'),
              _pill(
                patchNumber == null ? 'Base release' : 'Patch #$patchNumber',
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v16),
          Text(
            PlaygroundDemoContent.emoji,
            style: const TextStyle(fontSize: 48),
          ),
          SizedBox(height: AppSpacing.v8),
          Text(
            PlaygroundDemoContent.headline,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.whiteBase,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.v6),
          Text(
            PlaygroundDemoContent.message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.whiteBase.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSpacing.h10,
      vertical: AppSpacing.v4,
    ),
    decoration: BoxDecoration(
      color: AppColors.whiteBase.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(AppRadius.radius09),
    ),
    child: Text(
      text,
      style: AppTextStyles.labelSmall.copyWith(color: AppColors.whiteBase),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.h16),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all04,
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          SizedBox(height: AppSpacing.v10),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.available, required this.status});

  final bool available;
  final UpdateStatus? status;

  @override
  Widget build(BuildContext context) {
    final (String text, Color color) = !available
        ? ('Updater off', AppColors.warning600)
        : switch (status) {
            null => ('Updater on', AppColors.success600),
            UpdateStatus.upToDate => ('Up to date', AppColors.success600),
            UpdateStatus.outdated => ('Update available', AppColors.primary600),
            UpdateStatus.restartRequired => (
              'Restart required',
              AppColors.primary600,
            ),
            UpdateStatus.unavailable => ('Unavailable', AppColors.warning600),
          };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h10,
        vertical: AppSpacing.v4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.radius09),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CommandRow extends StatelessWidget {
  const _CommandRow({
    required this.step,
    required this.label,
    required this.command,
    required this.onCopy,
  });

  final String step;
  final String label;
  final String command;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.v10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 11,
            backgroundColor: AppColors.primary500,
            child: Text(
              step,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.whiteBase,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.h10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelMedium),
                SizedBox(height: AppSpacing.v2),
                Text(
                  command,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Copy',
            onPressed: () => onCopy(command),
            icon: const Icon(Icons.copy_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}
