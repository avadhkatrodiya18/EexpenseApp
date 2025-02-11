import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';
part 'expense_model.g.dart';


@HiveType(typeId: 0)
class ExpenseModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String paymentMethod;

  @HiveField(4)
  final DateTime timestamp;

  ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, category, amount, paymentMethod, timestamp];
}

