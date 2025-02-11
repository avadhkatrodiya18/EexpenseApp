import 'package:equatable/equatable.dart';
import 'package:expense/model/expense_model.dart';

abstract class ExpenseEvent {
  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expense;
  AddExpense(this.expense);
}

class UpdateExpense extends ExpenseEvent {
  final ExpenseModel expense;
  UpdateExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final String id;
  DeleteExpense(this.id);
}
