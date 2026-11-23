import 'package:flutter/material.dart';
import 'package:personal_money_management/models/category/category_model.dart';

class CategoryPopupRadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  const CategoryPopupRadioButton({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<CategoryType>(
          value: type,
        ),
        Text(title),
      ],
    );
  }
}
