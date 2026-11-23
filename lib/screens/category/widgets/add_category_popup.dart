import 'package:flutter/material.dart';
import 'package:personal_money_management/models/category/category_model.dart';
import 'package:personal_money_management/services/category/category_service.dart';

ValueNotifier<CategoryType> selectedCategoryNotifire = ValueNotifier(
  CategoryType.income,
);

final textController = TextEditingController();

Future<void> showAddCategoryPopup(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Text('Add Category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: selectedCategoryNotifire,
            builder:
                (BuildContext context, CategoryType newCategory, Widget? _) {
                  return RadioGroup(
                    onChanged: (value) {
                      if (value != null) {
                        selectedCategoryNotifire.value = value;
                      }
                    },
                    groupValue: newCategory,
                    child: Row(
                      children: [
                        Radio(value: CategoryType.income),
                        Text('Income'),
                        SizedBox(width: 30),
                        Radio(value: CategoryType.expense), Text('Expense'),
                        // CategoryPopupRadioButton(
                        //   title: 'Income',
                        //   type: CategoryType.income,
                        // ),
                        // CategoryPopupRadioButton(
                        //   title: 'Expense',
                        //   type: CategoryType.expense,
                        // ),
                      ],
                    ),
                  );
                },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: ElevatedButton(
              onPressed: () async {
                final text = textController.text;
                if (text.isEmpty) {
                  return;
                }
                final categoryType = selectedCategoryNotifire.value;
                final category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: text,
                  type: categoryType,
                );
                await HiveCategoryServices.shared.insertCategory(category);
                textController.clear();
                Navigator.of(ctx).pop();
              },
              child: Text('ADD'),
            ),
          ),
        ],
      );
    },
  );
}
