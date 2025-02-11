
import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/bloc/expense_state.dart';
import 'package:expense/screen/view/add_expense_screen.dart';
import 'package:expense/screen/view/budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Column(
        children: [
          // Budget Overview and Warning
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),blurRadius: 10,offset: Offset(0, 10))]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text("Total Expenses: ${state.totalExpenses}"),
                          if (state.totalExpenses > context.read<ExpenseBloc>().monthlyBudget)
                            Text(
                              "Warning: Budget Exceeded!",
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('My budget: ${context.read<ExpenseBloc>().monthlyBudget??''}'),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const BudgetScreen()),
                                  );
                                },
                                child: const Text("Manage Budget"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Filter Dropdowns
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),blurRadius: 10,offset: Offset(0, 10))]
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: _selectedCategory,


                      hint: const Text("Category"),
                      items: ["All", "Food", "Transport", "Shopping", "Bills"]
                          .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(
                        height: 30,
                        child: VerticalDivider(color: Colors.black,width: 2,)),
                    DropdownButton<String>(
                      value: _selectedPaymentMethod,
                      hint: const Text("Payment"),
                      items: ["All", "Cash", "Credit Card", "Debit Card", "UPI"]
                          .map((method) => DropdownMenuItem(value: method, child: Text(method)))
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
            ),
          ),

          // Expense List
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoaded) {
                  List<ExpenseModel> filteredExpenses = state.expenses;

                  if (_selectedCategory != null && _selectedCategory != "All") {
                    filteredExpenses = filteredExpenses
                        .where((expense) => expense.category == _selectedCategory)
                        .toList();
                  }
                  if (_selectedPaymentMethod != null && _selectedPaymentMethod != "All") {
                    filteredExpenses = filteredExpenses
                        .where((expense) => expense.paymentMethod == _selectedPaymentMethod)
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                          ),
                          child: ListTile(
                            title: Text(expense.category),
                            subtitle: Text("\$${expense.amount.toStringAsFixed(2)}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(expense.paymentMethod),
                                IconButton(
                                  icon: const Icon(Icons.delete,color: Colors.red,),
                                  onPressed: () {
                                    context.read<ExpenseBloc>().add(DeleteExpense(expense.id));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddExpenseScreen(expense: expense),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
