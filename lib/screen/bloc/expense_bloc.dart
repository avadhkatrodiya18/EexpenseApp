import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final Box<ExpenseModel> expenseBox;
  double monthlyBudget = 0.0;
  double totalExpenses = 0.0;

  ExpenseBloc(this.expenseBox) : super(ExpenseLoading()) {
    on<LoadExpenses>((event, emit) {
      final expenses = expenseBox.values.toList();
      totalExpenses = _calculateTotalExpenses(expenses);
      emit(ExpenseLoaded(expenses, totalExpenses: totalExpenses));
    });

    on<AddExpense>((event, emit) async {
      await expenseBox.put(event.expense.id, event.expense);
      await expenseBox.flush();

      final updatedExpenses = List<ExpenseModel>.from(expenseBox.values.toList());
      totalExpenses = _calculateTotalExpenses(updatedExpenses);

      emit(ExpenseLoaded(updatedExpenses, totalExpenses: totalExpenses));
    });

    on<UpdateExpense>((event, emit) {
      expenseBox.put(event.expense.id, event.expense);
      final updatedExpenses = List<ExpenseModel>.from(expenseBox.values.toList());
      totalExpenses = _calculateTotalExpenses(updatedExpenses);

      emit(ExpenseLoaded(updatedExpenses, totalExpenses: totalExpenses));
    });

    on<DeleteExpense>((event, emit) {
      expenseBox.delete(event.id);
      final updatedExpenses = List<ExpenseModel>.from(expenseBox.values.toList());
      totalExpenses = _calculateTotalExpenses(updatedExpenses);

      emit(ExpenseLoaded(updatedExpenses, totalExpenses: totalExpenses));
    });

    on<SetBudget>((event, emit) {
      monthlyBudget = event.budget;
      emit(BudgetUpdated(monthlyBudget));
    });
  }

  double _calculateTotalExpenses(List<ExpenseModel> expenses) {
    return expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}
