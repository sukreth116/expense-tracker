import 'package:flutter/material.dart';
import 'package:personal_money_management/screens/category/expenseCategory/expense_category_list.dart';
import 'package:personal_money_management/screens/category/incomeCategory/income_category_list.dart';
import 'package:personal_money_management/services/category/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    HiveCategoryServices().refreshUI();
    // HiveCategoryServices().getCategories().then((value) {}); //doubt .then()
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelColor: Colors.blueGrey,
          unselectedLabelColor: Colors.grey,
          controller: tabController,
          tabs: [
            Tab(text: 'INCOME'),
            Tab(text: 'EXPENSE'),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TabBarView(
              controller: tabController,
              children: [IncomeCategoryList(), ExpenseCategoryList()],
            ),
          ),
        ),
      ],
    );
  }
}
