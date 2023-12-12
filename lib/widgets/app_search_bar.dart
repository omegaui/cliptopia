import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/search_engine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:flutter/material.dart';

final _internalSearchController = TextEditingController();

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hint = "Find items in your clipboard",
    this.enabled = true,
  });

  final String hint;
  final bool enabled;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  TextEditingController searchFieldController = TextEditingController();
  final searchEngine = Injector.find<SearchEngine>();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 50),
      () => focusNode.requestFocus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: Image.asset(
              AppIcons.search,
              width: 32,
              height: 32,
            ),
          ),
          const SizedBox(width: 11),
          SizedBox(
            width: 250,
            height: 40,
            child: TextField(
              focusNode: focusNode,
              style: AppTheme.fontSize(16),
              enabled: widget.enabled,
              controller: _internalSearchController,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTheme.fontSize(16).copyWith(
                  color: AppTheme.hintColor,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.hintColor,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.hintColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.hintColor,
                  ),
                ),
              ),
              onChanged: (value) {
                searchEngine.search(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
