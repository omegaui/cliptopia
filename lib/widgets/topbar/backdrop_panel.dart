import 'package:cliptopia/widgets/app_search_bar.dart';
import 'package:cliptopia/widgets/topbar/filter_button.dart';
import 'package:cliptopia/widgets/topbar/power_mode_button.dart';
import 'package:flutter/material.dart';

class BackdropPanel extends StatelessWidget {
  const BackdropPanel({
    super.key,
    this.filterEnabled = true,
    this.searchBarEnabled = true,
    this.showSearchBar = true,
    this.searchHint = "Find items in your clipboard",
  });

  final bool filterEnabled;
  final bool searchBarEnabled;
  final bool showSearchBar;
  final String searchHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36, left: 36, right: 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PowerModeButton(),
              FilterButton(enabled: filterEnabled),
            ],
          ),
        ),
        if (showSearchBar)
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 33, right: 33),
            child: Row(
              children: [
                AppSearchBar(enabled: searchBarEnabled, hint: searchHint),
              ],
            ),
          ),
      ],
    );
  }
}
