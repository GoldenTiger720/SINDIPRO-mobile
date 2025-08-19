// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceBudget _$MaintenanceBudgetFromJson(Map<String, dynamic> json) =>
    MaintenanceBudget(
      id: json['id'] as String,
      condominium: json['condominium'] as String,
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      yearlyBudget: (json['yearlyBudget'] as num).toDouble(),
      remainingMonthly: (json['remainingMonthly'] as num).toDouble(),
      remainingYearly: (json['remainingYearly'] as num).toDouble(),
      expenses: (json['expenses'] as List<dynamic>)
          .map((e) => MaintenanceExpense.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$MaintenanceBudgetToJson(MaintenanceBudget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'condominium': instance.condominium,
      'monthlyBudget': instance.monthlyBudget,
      'yearlyBudget': instance.yearlyBudget,
      'remainingMonthly': instance.remainingMonthly,
      'remainingYearly': instance.remainingYearly,
      'expenses': instance.expenses,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

MaintenanceExpense _$MaintenanceExpenseFromJson(Map<String, dynamic> json) =>
    MaintenanceExpense(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      installments: (json['installments'] as num).toInt(),
      currentInstallment: (json['currentInstallment'] as num).toInt(),
      category: json['category'] as String,
      receipt: json['receipt'] as String?,
      purchasedBy: json['purchasedBy'] as String,
    );

Map<String, dynamic> _$MaintenanceExpenseToJson(MaintenanceExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'installments': instance.installments,
      'currentInstallment': instance.currentInstallment,
      'category': instance.category,
      'receipt': instance.receipt,
      'purchasedBy': instance.purchasedBy,
    };
