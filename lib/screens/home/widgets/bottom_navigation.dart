import 'package:flutter/material.dart';
import 'package:personal_money_management/screens/home/home.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Home.selectedIndexNotifer,
      builder: (ctx, updatedIndex, _) {
        return BottomNavigationBar(
          selectedItemColor: Colors.blueGrey,
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            Home.selectedIndexNotifer.value = newIndex;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
          ],
        );
      },
    );
  }
}
