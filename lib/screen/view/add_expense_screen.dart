import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/view/home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';


class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String selectedCategory = "Food";
  String selectedPaymentMethod = "Cash";

  final List<String> _categories = ["Food", "Transport", "Shopping", "Bills"];
  final List<String> _paymentMethods = ["Cash", "Credit Card", "Debit Card", "UPI"];

  void saveExpense() {
    if (_formKey.currentState!.validate()) {
      final newExpense = ExpenseModel(
        id: const Uuid().v4(),
        category: selectedCategory,
        amount: double.parse(_amountController.text),
        paymentMethod: selectedPaymentMethod,
        timestamp: DateTime.now(),
      );

      print("Dispatching AddExpense event: $newExpense"); // 🔥 Debug print

      context.read<ExpenseBloc>().add(AddExpense(newExpense));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (value) =>
                (value == null || value.isEmpty) ? "Enter amount" : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) => setState(() => selectedCategory = value!),
                items: _categories
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                onChanged: (value) => setState(() => selectedPaymentMethod = value!),
                items: _paymentMethods
                    .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                    .toList(),
                decoration: const InputDecoration(labelText: "Payment Method"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveExpense,
                child: const Text("Save Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
