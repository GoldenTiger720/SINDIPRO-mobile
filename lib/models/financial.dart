import 'package:json_annotation/json_annotation.dart';

part 'financial.g.dart';

@JsonSerializable()
class MaintenanceBudget {
  final String id;
  final String condominium;
  final double monthlyBudget;
  final double yearlyBudget;
  final double remainingMonthly;
  final double remainingYearly;
  final List<MaintenanceExpense> expenses;
  final DateTime lastUpdated;

  const MaintenanceBudget({
    required this.id,
    required this.condominium,
    required this.monthlyBudget,
    required this.yearlyBudget,
    required this.remainingMonthly,
    required this.remainingYearly,
    required this.expenses,
    required this.lastUpdated,
  });

  factory MaintenanceBudget.fromJson(Map<String, dynamic> json) => _$MaintenanceBudgetFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceBudgetToJson(this);

  double get spentThisMonth => monthlyBudget - remainingMonthly;
  double get spentThisYear => yearlyBudget - remainingYearly;
  double get monthlySpentPercentage => (spentThisMonth / monthlyBudget) * 100;
  double get yearlySpentPercentage => (spentThisYear / yearlyBudget) * 100;
}

@JsonSerializable()
class MaintenanceExpense {
  final String id;
  final String description;
  final double amount;
  final DateTime purchaseDate;
  final int installments;
  final int currentInstallment;
  final String category;
  final String? receipt; // path to receipt image
  final String purchasedBy;

  const MaintenanceExpense({
    required this.id,
    required this.description,
    required this.amount,
    required this.purchaseDate,
    required this.installments,
    required this.currentInstallment,
    required this.category,
    this.receipt,
    required this.purchasedBy,
  });

  factory MaintenanceExpense.fromJson(Map<String, dynamic> json) => _$MaintenanceExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceExpenseToJson(this);

  double get monthlyInstallmentAmount => amount / installments;
  bool get isFullyPaid => currentInstallment >= installments;
  double get remainingAmount => (installments - currentInstallment) * monthlyInstallmentAmount;
}