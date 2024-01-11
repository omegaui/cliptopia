import 'package:cliptopia/app/powermode/domain/entity/text_entity.dart';
import 'package:cliptopia/app/powermode/domain/text_type.dart';
import 'package:cliptopia/app/powermode/presentation/power_mode_controller.dart';
import 'package:cliptopia/app/powermode/presentation/widgets/styled_text_card.dart';
import 'package:cliptopia/app/powermode/presentation/widgets/text_filter_group.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PowerModeTextViewStateView extends StatefulWidget {
  const PowerModeTextViewStateView({
    super.key,
    required this.controller,
  });

  final PowerModeController controller;

  @override
  State<PowerModeTextViewStateView> createState() =>
      _PowerModeTextViewStateViewState();
}

class _PowerModeTextViewStateViewState
    extends State<PowerModeTextViewStateView> {
  String currentFilter = 'all';
  final Map<TextEntity, TextType> _textTypeMap = {};
  final Map<String, int> _filterStats = {
    'All': 0,
    'Code': 0,
    'Url': 0,
    'Word': 0,
    'Sentence': 0,
    'Paragraph': 0,
  };

  @override
  void initState() {
    super.initState();
    final texts = PowerDataHandler.texts
        .where((e) =>
            !e.entity.isMarkedDeleted &&
            (e.search(PowerDataHandler.searchText)))
        .where((e) =>
            !e.entity.info.sensitive ||
            !Storage.isSensitivityOn() ||
            TempStorage.canShowSensitiveContent());
    for (final text in texts) {
      final type = determineTextType(text.text);
      _textTypeMap[text] = type;
      _filterStats['All'] = _filterStats['All']! + 1;
      switch (type) {
        case TextType.code:
          _filterStats['Code'] = _filterStats['Code']! + 1;
          break;
        case TextType.url:
          _filterStats['Url'] = _filterStats['Url']! + 1;
          break;
        case TextType.word:
          _filterStats['Word'] = _filterStats['Word']! + 1;
          break;
        case TextType.sentence:
          _filterStats['Sentence'] = _filterStats['Sentence']! + 1;
          break;
        case TextType.paragraph:
          _filterStats['Paragraph'] = _filterStats['Paragraph']! + 1;
      }
    }
  }

  bool filter(TextType value) {
    if (currentFilter == 'all') {
      return true;
    }
    return currentFilter == value.name;
  }

  @override
  Widget build(BuildContext context) {
    final defaultViewMode = Storage.get(StorageKeys.viewMode,
            fallback: StorageValues.defaultViewMode) ==
        StorageValues.defaultViewMode;
    return Scaffold(
      backgroundColor:
          defaultViewMode ? PowerModeTheme.barrier : Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 150, vertical: 60),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: PowerModeTheme.background,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: PowerModeTheme.borderColor),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(PowerModeTheme.dropShadowOpacity),
                blurRadius: 48,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      widget.controller.gotoHomeView();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey.shade800,
                    ),
                    iconSize: 32,
                  ),
                  const Gap(10),
                  Text(
                    "Clipboard Text",
                    style: AppTheme.fontSize(32),
                  ),
                ],
              ),
              const Gap(10),
              TextFilterGroup(
                stats: _filterStats,
                onChanged: (filter) {
                  setState(() {
                    currentFilter = filter.toLowerCase();
                  });
                },
              ),
              const Gap(10),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _textTypeMap.entries
                        .where((e) => filter(e.value))
                        .map(
                          (e) => StyledTextCard(
                            entity: e.key,
                            type: e.value,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
