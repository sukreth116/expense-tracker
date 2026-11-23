import 'package:flutter/material.dart';
import 'package:personal_money_management/models/category/category_model.dart';
import 'package:personal_money_management/models/transaction/transaction_model.dart';
import 'package:personal_money_management/services/category/category_service.dart';
import 'package:personal_money_management/services/transaction/transaction_service.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final purposeController = TextEditingController();
  final amountController = TextEditingController();
  CategoryType? selectedCategoryType = CategoryType.income;
  CategoryModel? selectedCategoryModel;
  String? selectedCategoryId;
  DateTime? _selectedDate;

  @override
  void initState() {
    selectedCategoryType = CategoryType.income;
    super.initState();
  }

  Future<void> addTransaction() async {
    final purposeText = purposeController.text;
    final amountText = amountController.text;
    final parsedAmount = double.tryParse(amountText);
    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    if (parsedAmount == null) {
      return;
    }
    if (selectedCategoryModel == null) {
      return;
    }
    if (selectedCategoryType == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }

    final transaction = TransactionModel(
      purpose: purposeController.text,
      amount: parsedAmount,
      date: _selectedDate!,
      type: selectedCategoryType!,
      category: selectedCategoryModel!,
    );
    await HiveTransactionService.instance.insertTransaction(transaction);
    await HiveTransactionService.instance.loadTransaction();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: purposeController,
                decoration: InputDecoration(hintText: 'Purpose'),
              ),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Amount'),
              ),
              TextButton.icon(
                onPressed: () async {
                  final selectedTempDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 10)),
                    initialDate: DateTime.now(),
                  );
                  if (selectedTempDate != null) {
                    setState(() {
                      _selectedDate = selectedTempDate;
                    });
                  }
                },
                icon: Icon(Icons.calendar_month),
                label: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate.toString(),
                ),
              ),
              RadioGroup(
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      selectedCategoryType = value;
                      selectedCategoryId = null;
                    }
                  });
                },
                groupValue: selectedCategoryType,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio(value: CategoryType.income),
                        Text('Income'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: CategoryType.expense),
                        Text('Expense'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Select Item'),
                      value: selectedCategoryId,
                      items:
                          (selectedCategoryType == CategoryType.income
                                  ? HiveCategoryServices()
                                        .incomeCategoryListListener
                                  : HiveCategoryServices()
                                        .expenseCategoryListListener)
                              .value
                              .map((e) {
                                return DropdownMenuItem(
                                  onTap: () {
                                    selectedCategoryModel = e;
                                  },
                                  value: e.id,
                                  child: Text(e.name),
                                );
                              })
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await addTransaction();
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
