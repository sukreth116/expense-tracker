import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_money_management/models/category/category_model.dart';
import 'package:personal_money_management/models/transaction/transaction_model.dart';
import 'package:personal_money_management/services/transaction/transaction_service.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    String parseDate(DateTime date) {
      final dateParsed = DateFormat.MMMd().format(date);
      final dateSplited = dateParsed.split(' ');
      final dateFinal = '${dateSplited.last}\n${dateSplited.first}';
      return dateFinal;
    }

    HiveTransactionService.instance.loadTransaction();
    return ValueListenableBuilder(
      valueListenable: HiveTransactionService.instance.transactionListNotifier,
      builder:
          (BuildContext context, List<TransactionModel> newList, Widget? _) {
            return ListView.separated(
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final value = newList[index];
                return Dismissible(
                  key: Key(value.transactionId!),
                  confirmDismiss: (direction) async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Delete!'),
                          content: const Text(
                            'Are you sure you want to delete this transaction?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(true);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldDelete == true) {
                      await HiveTransactionService.instance.deleteTransaction(
                        value.transactionId!,
                      );

                      return true;
                    }

                    return false;
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${value.amount}\n${value.purpose}'),
                      leading: CircleAvatar(
                        backgroundColor: value.type == CategoryType.income
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                        foregroundColor: Colors.white,
                        radius: 30,
                        child: Text(
                          parseDate(value.date),
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      subtitle: Text(value.category.name),
                      trailing: Text(value.category.type.name),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 5);
              },
              itemCount: newList.length,
            );
          },
    );
  }
}
