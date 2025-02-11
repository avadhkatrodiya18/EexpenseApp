import 'package:expense/model/expense_model.dart';
import 'package:expense/screen/bloc/expense_bloc.dart';
import 'package:expense/screen/bloc/expense_event.dart';
import 'package:expense/screen/view/single_user_expense_screen.dart';
import 'package:expense/screen/view/user_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');

  runApp(MyApp(expenseBox: expenseBox));
}

class MyApp extends StatelessWidget {
  final Box<ExpenseModel> expenseBox;

  const MyApp({super.key, required this.expenseBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseBloc(expenseBox)..add(LoadExpenses()),
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: UserSelectionScreen(),
      ),
    );
  }
}
