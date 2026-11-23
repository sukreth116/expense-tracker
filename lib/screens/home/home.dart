import 'package:flutter/material.dart';
import 'package:personal_money_management/constans/routes.dart';
import 'package:personal_money_management/screens/category/category_screen.dart';
import 'package:personal_money_management/screens/category/widgets/add_category_popup.dart';
import 'package:personal_money_management/screens/home/widgets/bottom_navigation.dart';
import 'package:personal_money_management/screens/transactions/transactionScreen/transactions_screen.dart';
import 'package:personal_money_management/services/category/category_service.dart';

class Home extends StatelessWidget {
  Home({super.key});
  static ValueNotifier<int> selectedIndexNotifer = ValueNotifier(0);
  final _pages = [TransactionsScreen(), CategoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MONEY MANAGER')),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifer,
          builder: (context, updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueGrey,
        onPressed: () async {
          if (selectedIndexNotifer.value == 0) {
            await HiveCategoryServices.shared.refreshUI();
            Navigator.of(context).pushNamed(addTransactionRoute);
          } else {
            await showAddCategoryPopup(context);
          }
        },
        child: Icon(Icons.add_circle_outline_rounded),
      ),
    );
  }
}
