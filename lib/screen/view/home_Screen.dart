import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/bloc/expense_state.dart';
import 'package:expense/screen/view/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<ExpenseBloc>();
    print("ExpenseBloc exists: $bloc"); // 🔥 Debug print

    bloc.add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _selectedCategory,
                  hint: const Text("Category"),
                  items: ["All", "Food", "Transport", "Shopping", "Bills"]
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  hint: const Text("Payment"),
                  items: ["All", "Cash", "Credit Card", "Debit Card", "UPI"]
                      .map((method) =>
                          DropdownMenuItem(value: method, child: Text(method)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: BlocBuilder<ExpenseBloc, ExpenseState>(

            builder: (context, state) {
              print("state===> $state I===> ${state is ExpenseLoaded}");
              if (state is ExpenseLoaded) {
                print("🖥️ UI Updated with ${state.expenses.length} expenses");

                List<ExpenseModel> filteredExpenses = state.expenses;
                print("state.expenses==> ${state.expenses.length}");

                if (_selectedCategory != null && _selectedCategory != "All") {
                  filteredExpenses = filteredExpenses
                      .where((expense) => expense.category == _selectedCategory)
                      .toList();
                }
                if (_selectedPaymentMethod != null &&
                    _selectedPaymentMethod != "All") {
                  filteredExpenses = filteredExpenses
                      .where((expense) =>
                          expense.paymentMethod == _selectedPaymentMethod)
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
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(
              "context.read<ExpenseBloc>()===> ${context.read<ExpenseBloc>().expenseBox.length}");
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );

          // if (context.mounted) {
          //   print("🔄 Reloading expenses after returning...");
          //   context.read<ExpenseBloc>().add(LoadExpenses()); // 🔥 Reload
          // }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
