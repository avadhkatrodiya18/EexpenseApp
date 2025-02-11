import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final Box<ExpenseModel> expenseBox;

  ExpenseBloc(this.expenseBox) : super(ExpenseLoading()) {
    on<LoadExpenses>((event, emit) {
      final expenses = expenseBox.values.toList();
      emit(ExpenseLoaded(expenses));
    });

    on<AddExpense>((event, emit) {
      expenseBox.put(event.expense.id, event.expense);
      add(LoadExpenses());
    });

    on<UpdateExpense>((event, emit) {
      expenseBox.put(event.expense.id, event.expense);
      add(LoadExpenses());
    });

    on<DeleteExpense>((event, emit) {
      expenseBox.delete(event.id);
      add(LoadExpenses());
    });
  }
}
