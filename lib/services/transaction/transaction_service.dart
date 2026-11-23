import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_management/models/transaction/transaction_model.dart';

const transactionBox = 'transaction-box';

abstract class TransactionService {
  Future<void> insertTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransaction();
  Future<void> deleteTransaction(String transactionId);
}

class HiveTransactionService implements TransactionService {
  ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier(
    [],
  );

  HiveTransactionService._sharedInstance();

  static HiveTransactionService instance =
      HiveTransactionService._sharedInstance();

  factory HiveTransactionService() {
    return instance;
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final box = await Hive.openBox<TransactionModel>(transactionBox);
    await box.delete(transactionId);
    await loadTransaction();
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    final box = await Hive.openBox<TransactionModel>(transactionBox);
    return box.values.toList();
  }

  @override
  Future<void> insertTransaction(TransactionModel transaction) async {
    final box = await Hive.openBox<TransactionModel>(transactionBox);
    await box.put(transaction.transactionId, transaction);
  }

  Future<void> loadTransaction() async {
    final list = await getTransaction();
    list.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(list);
    transactionListNotifier.notifyListeners();
  }
}
