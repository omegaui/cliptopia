import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/emojis/domain/typedefs.dart';
import 'package:cliptopia/app/emojis/presentation/emojis_controller.dart';
import 'package:cliptopia/app/emojis/presentation/widgets/category_panel.dart';
import 'package:cliptopia/app/emojis/presentation/widgets/emoji_tile.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmojisInitializedStateView extends StatefulWidget {
  const EmojisInitializedStateView({
    super.key,
    required this.controller,
  });

  final EmojisController controller;

  @override
  State<EmojisInitializedStateView> createState() =>
      _EmojisInitializedStateViewState();
}

class _EmojisInitializedStateViewState
    extends State<EmojisInitializedStateView> {
  late DatabaseWatcher databaseWatcher;

  EmojiCategory selectedCategory = EmojiCategory.all;

  void rebuild() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    databaseWatcher = DatabaseWatcher.permanent(
      onEvent: (entities) {
        rebuild();
      },
      filters: [ClipboardEntityType.text],
    );
    Injector.find<Database>().addWatcher(databaseWatcher);
  }

  @override
  void dispose() {
    databaseWatcher.dispose();
    super.dispose();
  }

  Widget _buildItems() {
    final emojis = widget.controller.getEmojis();
    final tiles = emojis.where((e) {
      if (selectedCategory == EmojiCategory.all ||
          e.category == selectedCategory) {
        return true;
      }
      return false;
    }).map((e) {
      return EmojiTile(entity: e);
    }).toList();
    if (tiles.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 700,
            child: Center(
              child: Lottie.asset(
                AppAnimations.emojis,
                width: 200,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Text(
            "No Emojis in this category",
            style: AppTheme.fontSize(16),
          ),
        ],
      );
    }
    return SingleChildScrollView(
      child: Wrap(
        runSpacing: 25,
        spacing: 25,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          ...tiles,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            child: Container(
              width: 700,
              height: 600,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.windowDropShadowColor,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: TopBar(
                      enabled: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 110.0, left: 36),
                      child: SizedBox(
                        width: 700,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Filter Emojis by Category",
                              style: AppTheme.fontSize(20).makeBold(),
                            ),
                            const SizedBox(height: 20),
                            CategoryPanel(
                              onChange: (category) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                            ),
                            const SizedBox(height: 36),
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: _buildItems(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: AppCloseButton(),
          ),
        ],
      ),
    );
  }
}
