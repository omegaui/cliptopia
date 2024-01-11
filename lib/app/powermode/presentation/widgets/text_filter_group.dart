import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class TextFilterGroup extends StatefulWidget {
  const TextFilterGroup({
    super.key,
    required this.stats,
    required this.onChanged,
  });

  final Map<String, int> stats;
  final void Function(String filter) onChanged;

  @override
  State<TextFilterGroup> createState() => _TextFilterGroupState();
}

class _TextFilterGroupState extends State<TextFilterGroup> {
  String currentFilter = 'All';
  final filters = [];

  @override
  void initState() {
    super.initState();
    filters.addAll(['All', 'Code', 'Url', 'Word', 'Sentence', 'Paragraph']);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: filters.map((e) {
        return TextFilterButton(
          filter: e,
          itemCount: widget.stats[e]!,
          onSelected: () {
            setState(() {
              currentFilter = e;
              widget.onChanged(e);
            });
          },
          active: currentFilter == e,
        );
      }).toList(),
    );
  }
}

class TextFilterButton extends StatefulWidget {
  const TextFilterButton({
    super.key,
    required this.filter,
    required this.itemCount,
    required this.onSelected,
    required this.active,
  });

  final String filter;
  final int itemCount;
  final VoidCallback onSelected;
  final bool active;

  @override
  State<TextFilterButton> createState() => _TextFilterButtonState();
}

class _TextFilterButtonState extends State<TextFilterButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 50),
      scale: hover ? 1.1 : 1.0,
      child: GestureDetector(
        onTap: widget.onSelected,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (e) => setState(() => hover = true),
          onExit: (e) => setState(() => hover = false),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.active
                  ? PowerModeTheme.activeImageFilterBackgroundColor
                  : PowerModeTheme.collectionCardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "${widget.filter} (${widget.itemCount})",
              style: AppTheme.fontSize(16).copyWith(
                fontWeight: widget.active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
