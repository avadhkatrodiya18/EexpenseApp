import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_state.dart';
import 'package:expense/screen/view/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SingleUserExpenseViewScreen extends StatefulWidget {
  const SingleUserExpenseViewScreen({super.key});

  @override
  SingleUserExpenseViewScreenState createState() => SingleUserExpenseViewScreenState();
}

class SingleUserExpenseViewScreenState extends State<SingleUserExpenseViewScreen> {
  String? selectedCategory;
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text("Category"),
                  items: ["All", "Food", "Transport", "Shopping", "Bills"]
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedCategory = value),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPaymentMethod,
                  hint: const Text("Payment"),
                  items: ["All", "Cash", "Credit Card", "Debit Card", "UPI"]
                      .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedPaymentMethod = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoaded) {
                  List<ExpenseModel> filteredExpenses = state.expenses;

                  if (selectedCategory != null && selectedCategory != "All") {
                    filteredExpenses = filteredExpenses
                        .where((expense) => expense.category == selectedCategory)
                        .toList();
                  }
                  if (selectedPaymentMethod != null && selectedPaymentMethod != "All") {
                    filteredExpenses = filteredExpenses
                        .where((expense) => expense.paymentMethod == selectedPaymentMethod)
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return ListTile(
                        title: Text(expense.category),
                        subtitle: Text("\$${expense.amount.toStringAsFixed(2)}"),
                        trailing: Text(expense.paymentMethod),
                      );
                    },
                  );
                }
                return const Center(child: Text("No expenses found"));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpenseScreen()),
        ),
        child: const Icon(Icons.add),
      ),

    );
  }
}
