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
      print("📌 LoadExpenses event received!");

      // Ensure updated state is emitted
      final updatedExpenses = List.from(expenses);
      print(
          "🚀 Emitting ExpenseLoaded with ${updatedExpenses.length} expenses");

      emit(ExpenseLoaded(expenses));
    });

    on<AddExpense>((event, emit) async {
      print("🔵 Adding expense: ${event.expense}");
      print(
          "expenseBox.values.toList()===> ${expenseBox.values.toList().length}");
      await expenseBox.put(
          event.expense.id, event.expense); // Ensure data is saved properly
      await expenseBox.flush(); // 🚀 Force Hive to save data immediately

      final updatedExpenses = List<ExpenseModel>.from(expenseBox.values.toList());
      print("✅ Updated expenses count: ${updatedExpenses.length}");

      emit(ExpenseLoaded(updatedExpenses)); // ✅ Emit state update

      // 🚀 Immediately reload expenses
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
