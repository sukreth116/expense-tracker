import 'package:flutter/material.dart';
import 'package:personal_money_management/models/category/category_model.dart';
import 'package:personal_money_management/services/category/category_service.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveCategoryServices().incomeCategoryListListener,
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        return ListView.separated(
          itemBuilder: (context, index) {
            final category = newList[index];
            return SizedBox(
              height: 100,
              child: Card(
                child: Center(
                  child: ListTile(
                    title: Text(category.name),
                    trailing: IconButton(
                      onPressed: () async {
                        await HiveCategoryServices().deleteCategory(
                          category.id,
                        );
                      },
                      icon: Icon(Icons.delete_outline),
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
