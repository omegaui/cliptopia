import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:flutter/material.dart';

class PowerSearchField extends StatefulWidget {
  const PowerSearchField({super.key});

  @override
  State<PowerSearchField> createState() => _PowerSearchFieldState();
}

class _PowerSearchFieldState extends State<PowerSearchField> {
  final focusNode = FocusNode();

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        PowerDataHandler.searchTypeChangeListeners.add(() {
          if (mounted) {
            setState(() {});
          }
        });
        focusNode.requestFocus();
      },
    );
  }

  _createInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 490,
      height: 45,
      decoration: BoxDecoration(
        color: PowerModeTheme.searchFieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: AppTheme.fontSize(14).makeMedium(),
        cursorOpacityAnimates: true,
        onChanged: (value) {
          PowerDataHandler.searchTextUpdate(value);
        },
        decoration: InputDecoration(
          hintText: "Search your clipboard contents ....",
          hintStyle: AppTheme.fontSize(14)
              .withColor(PowerModeTheme.searchFieldHintColor)
              .makeMedium(),
          border: _createInputBorder(PowerModeTheme.searchFieldBorderColor),
          enabledBorder:
              _createInputBorder(PowerModeTheme.searchFieldBorderColor),
          focusedBorder:
              _createInputBorder(PowerModeTheme.searchFieldBorderEnabledColor),
          suffix: DropdownButton<PowerSearchType>(
            borderRadius: BorderRadius.circular(10),
            items: PowerSearchType.values
                .where((e) =>
                    !Storage.get(StorageKeys.hideImagePanelKey,
                        fallback: false) ||
                    e != PowerSearchType.Image)
                .map((e) => DropdownMenuItem<PowerSearchType>(
                      value: e,
                      child: Text(
                        e.name,
                        style: AppTheme.fontSize(14).makeMedium(),
                      ),
                    ))
                .toList(),
            value: PowerDataHandler.searchType,
            onChanged: (value) {
              PowerDataHandler.searchTypeUpdate(value!);
              focusNode.requestFocus();
            },
          ),
        ),
      ),
    );
  }
}
