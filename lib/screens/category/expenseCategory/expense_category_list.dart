import 'package:flutter/material.dart';
import 'package:personal_money_management/models/category/category_model.dart';
import 'package:personal_money_management/services/category/category_service.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveCategoryServices().expenseCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final expense = newList[index];
            return SizedBox(
              height: 100,
              child: Card(
                child: Center(
                  child: ListTile(
                    title: Text(expense.name),
                    trailing: IconButton(
                      onPressed: () async {
                        await HiveCategoryServices().deleteCategory(expense.id);
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: newList.length,
          separatorBuilder: (context, index) {
            return SizedBox();
          },
        );
      },
    );
  }
}
