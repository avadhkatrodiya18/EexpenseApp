import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/bloc/expense_state.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _budgetController = TextEditingController();

  void setBudget() {
    double budget = double.tryParse(_budgetController.text) ?? 0.0;
    context.read<ExpenseBloc>().add(SetBudget(budget));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set Monthly Budget")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter Budget"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: setBudget,
              child: const Text("Save Budget"),
            ),
            const SizedBox(height: 20),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is BudgetUpdated) {
                  return Text(
                    "Current Budget: ${state.monthlyBudget}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                }
                return const Text("No budget set yet.");
              },
            ),
          ],
        ),
      ),
    );
  }
}
