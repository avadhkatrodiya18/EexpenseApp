import 'package:expense/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseChart extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    final data = categoryTotals.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();

    return SizedBox(
      height: 300,
      child: SfCircularChart(
        title: ChartTitle(text: "Expense Breakdown"),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.amount,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}

class ChartData {
  final String category;
  final double amount;

  ChartData(this.category, this.amount);
}
