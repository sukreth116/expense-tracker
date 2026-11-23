import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_management/models/category/category_model.dart';

const categoryBox = 'category-box';

abstract class CategoryService {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel category);
  Future<void> deleteCategory(String categoryId);
}

class HiveCategoryServices implements CategoryService {
  ValueNotifier<List<CategoryModel>> incomeCategoryListListener = ValueNotifier(
    [],
  );
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
      ValueNotifier([]);

  HiveCategoryServices._sharedInstance();

  static HiveCategoryServices shared = HiveCategoryServices._sharedInstance();
  factory HiveCategoryServices() => shared;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryBox);
    return categoryDB.values.toList();
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryBox);
    await categoryDB.put(value.id, value);
    await refreshUI();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    expenseCategoryListListener.value.clear();
    incomeCategoryListListener.value.clear();
    await Future.forEach(allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListListener.value.add(category);
      } else {
        expenseCategoryListListener.value.add(category);
      }
    });
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    expenseCategoryListListener.notifyListeners();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    incomeCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryBox);
    await categoryDB.delete(categoryId);
    refreshUI();
  }
}
