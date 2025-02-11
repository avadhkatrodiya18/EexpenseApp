import 'package:equatable/equatable.dart';
import 'package:expense/model/expense_model.dart';

abstract class ExpenseState {
  @override
  List<Object> get props => [];
}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  ExpenseLoaded(this.expenses);
}
