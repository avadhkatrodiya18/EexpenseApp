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

    on<AddExpense>((event, emit) async {
    await expenseBox.put(
          event.expense.id, event.expense);
      await expenseBox.flush();

      final updatedExpenses = List<ExpenseModel>.from(expenseBox.values.toList());

      emit(ExpenseLoaded(updatedExpenses));

      add(LoadExpenses());
    });

    on<UpdateExpense>((event, emit) {
      expenseBox.put(event.expense.id, event.expense);
      emit(ExpenseLoaded(expenseBox.values.toList()));
    });

    on<DeleteExpense>((event, emit) {
      expenseBox.delete(event.id);
      emit(ExpenseLoaded(expenseBox.values.toList()));
    });
  }
}
