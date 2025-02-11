
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_event.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String selectedCategory = "Food";
  String selectedPaymentMethod = "Cash";

  final List<String> _categories = ["Food", "Transport", "Shopping", "Bills"];
  final List<String> _paymentMethods = ["Cash", "Credit Card", "Debit Card", "UPI"];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      selectedCategory = widget.expense!.category;
      selectedPaymentMethod = widget.expense!.paymentMethod;
    }
  }

  void saveExpense() {
    if (_formKey.currentState!.validate()) {
      final newExpense = ExpenseModel(
        id: widget.expense?.id ?? const Uuid().v4(),
        category: selectedCategory,
        amount: double.parse(_amountController.text),
        paymentMethod: selectedPaymentMethod,
        timestamp: widget.expense?.timestamp ?? DateTime.now(),
      );

      if (widget.expense == null) {
        context.read<ExpenseBloc>().add(AddExpense(newExpense));
      } else {
        context.read<ExpenseBloc>().add(UpdateExpense(newExpense));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.expense == null ? "Add Expense" : "Edit Expense")),
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
                child: Text(widget.expense == null ? "Save Expense" : "Update Expense"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
