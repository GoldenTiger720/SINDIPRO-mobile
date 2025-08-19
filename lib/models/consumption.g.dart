// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumptionReading _$ConsumptionReadingFromJson(Map<String, dynamic> json) =>
    ConsumptionReading(
      id: json['id'] as String,
      condominium: json['condominium'] as String,
      unit: json['unit'] as String,
      meterType: json['meterType'] as String,
      reading: (json['reading'] as num).toDouble(),
      readingDate: DateTime.parse(json['readingDate'] as String),
      readBy: json['readBy'] as String,
      notes: json['notes'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ConsumptionReadingToJson(ConsumptionReading instance) =>
    <String, dynamic>{
      'id': instance.id,
      'condominium': instance.condominium,
      'unit': instance.unit,
      'meterType': instance.meterType,
      'reading': instance.reading,
      'readingDate': instance.readingDate.toIso8601String(),
      'readBy': instance.readBy,
      'notes': instance.notes,
      'photos': instance.photos,
    };

ConsumptionData _$ConsumptionDataFromJson(Map<String, dynamic> json) =>
    ConsumptionData(
      unit: json['unit'] as String,
      meterType: json['meterType'] as String,
      monthlyData: (json['monthlyData'] as List<dynamic>)
          .map((e) => MonthlyConsumption.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageConsumption: (json['averageConsumption'] as num).toDouble(),
      lastReading: (json['lastReading'] as num).toDouble(),
      lastReadingDate: DateTime.parse(json['lastReadingDate'] as String),
    );

Map<String, dynamic> _$ConsumptionDataToJson(ConsumptionData instance) =>
    <String, dynamic>{
      'unit': instance.unit,
      'meterType': instance.meterType,
      'monthlyData': instance.monthlyData,
      'averageConsumption': instance.averageConsumption,
      'lastReading': instance.lastReading,
      'lastReadingDate': instance.lastReadingDate.toIso8601String(),
    };

MonthlyConsumption _$MonthlyConsumptionFromJson(Map<String, dynamic> json) =>
    MonthlyConsumption(
      month: json['month'] as String,
      consumption: (json['consumption'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyConsumptionToJson(MonthlyConsumption instance) =>
    <String, dynamic>{
      'month': instance.month,
      'consumption': instance.consumption,
      'cost': instance.cost,
    };
