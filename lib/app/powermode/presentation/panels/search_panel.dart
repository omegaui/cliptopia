import 'package:cliptopia/app/powermode/presentation/dialogs/daemon_manager_dialog.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/power_mode_settings.dart';
import 'package:cliptopia/app/powermode/presentation/panels/widgets/date_filter.dart';
import 'package:cliptopia/app/powermode/presentation/panels/widgets/power_search_field.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class SearchPanel extends StatefulWidget {
  const SearchPanel({super.key});

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  bool isBackgroundServiceAlive = true;

  @override
  void initState() {
    super.initState();
    isBackgroundServiceAlive = Storage.get(
            StorageKeys.dontShowDaemonSleepingDialogKey,
            fallback: false) ||
        isDaemonAlive();
    PowerDataHandler.hoverChangeListeners.add(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget _buildEntityInfo() {
    if (PowerDataHandler.hoveringEntity == null) {
      return SizedBox(
          key: ValueKey('hidden-state-${DateTime.now().toString()}'));
    }
    String message =
        "${DateFormat.yMMMMEEEEd('en_us').format(PowerDataHandler.hoveringEntity!.time)} ${DateFormat('K:mm:ss a').format(PowerDataHandler.hoveringEntity!.time)}";
    return Row(
      key: ValueKey('entity-info-${DateTime.now().toString()}'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info,
          color: AppTheme.foreground2,
        ),
        const Gap(8),
        Text(
          message,
          style: AppTheme.fontSize(14).makeMedium(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: windowSize.width,
      height: 60,
      decoration: BoxDecoration(
        color: PowerModeTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PowerModeTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(PowerModeTheme.dropShadowOpacity),
            blurRadius: 48,
          )
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            AppIcons.search,
            width: 32,
            height: 32,
          ),
          const Gap(11),
          const PowerSearchField(),
          const Gap(11),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildEntityInfo(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Go Incognito",
                  style: AppTheme.fontSize(14).makeBold(),
                ),
                const Gap(4),
                Switch(
                  value: IncognitoLock.isLocked(),
                  onChanged: (value) {
                    setState(() {
                      if (IncognitoLock.isLocked()) {
                        IncognitoLock.remove();
                      } else {
                        IncognitoLock.apply();
                      }
                    });
                  },
                ),
                const Gap(10),
                const DateFilter(),
                const Gap(8),
                IconButton(
                  onPressed: () {
                    PowerDataHandler.toggleSortMode();
                  },
                  icon: Image.asset(
                    AppIcons.filter,
                    width: 24,
                  ),
                ),
                const Gap(8),
                IconButton(
                  tooltip: "Toggle Sorting Mode",
                  onPressed: () {
                    PowerDataHandler.toggleSortMode();
                  },
                  icon: Icon(
                    isBackgroundServiceAlive ? Icons.settings : Icons.warning,
                    size: 24,
                    color: isBackgroundServiceAlive ? null : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
