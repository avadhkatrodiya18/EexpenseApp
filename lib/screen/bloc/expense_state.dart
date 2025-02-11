import 'package:expense/model/expense_model.dart';


abstract class ExpenseState {
  @override
  List<Object> get props => [];
}

class ExpenseLoading extends ExpenseState {}
//
// class ExpenseLoaded extends ExpenseState {
//   final List<ExpenseModel> expenses;
//   ExpenseLoaded(this.expenses);
// }

class ExpenseInitial extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  final double totalExpenses;

  ExpenseLoaded(this.expenses, {required this.totalExpenses});
}

class BudgetUpdated extends ExpenseState {
  final double monthlyBudget;
  BudgetUpdated(this.monthlyBudget);
}