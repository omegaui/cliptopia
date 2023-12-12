import 'package:cliptopia/app/emojis/domain/typedefs.dart';
import 'package:cliptopia/app/emojis/presentation/widgets/category_button.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:flutter/material.dart';

class CategoryPanel extends StatefulWidget {
  const CategoryPanel({
    super.key,
    required this.onChange,
  });

  final CategoryChangeCallback onChange;

  @override
  State<CategoryPanel> createState() => _CategoryPanelState();
}

class _CategoryPanelState extends State<CategoryPanel> {
  EmojiCategory category = EmojiCategory.all;

  void changeTo(EmojiCategory selection) {
    if (category == selection) {
      return;
    }
    setState(() {
      category = selection;
      widget.onChange(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 25,
      runSpacing: 25,
      children: [
        CategoryButton(
          active: category == EmojiCategory.all,
          tooltip: "All Emojis",
          icon: AppIcons.star,
          onPressed: () => changeTo(EmojiCategory.all),
        ),
        CategoryButton(
          active: category == EmojiCategory.face,
          tooltip: "Smileys & People",
          icon: AppIcons.face,
          onPressed: () => changeTo(EmojiCategory.face),
        ),
        CategoryButton(
          active: category == EmojiCategory.cloth,
          tooltip: "Body & Clothing",
          icon: AppIcons.cloth,
          onPressed: () => changeTo(EmojiCategory.cloth),
        ),
        CategoryButton(
          active: category == EmojiCategory.animal,
          tooltip: "Animals & Nature",
          icon: AppIcons.animal,
          onPressed: () => changeTo(EmojiCategory.animal),
        ),
        CategoryButton(
          active: category == EmojiCategory.food,
          tooltip: "Food & Drink",
          icon: AppIcons.food,
          onPressed: () => changeTo(EmojiCategory.food),
        ),
        CategoryButton(
          active: category == EmojiCategory.misc,
          tooltip: "Other Types",
          icon: AppIcons.misc,
          onPressed: () => changeTo(EmojiCategory.misc),
        ),
      ],
    );
  }
}
