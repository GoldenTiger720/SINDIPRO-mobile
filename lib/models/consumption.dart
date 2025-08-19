import 'package:json_annotation/json_annotation.dart';

part 'consumption.g.dart';

@JsonSerializable()
class ConsumptionReading {
  final String id;
  final String condominium;
  final String unit;
  final String meterType; // 'water', 'gas', 'electricity'
  final double reading;
  final DateTime readingDate;
  final String readBy; // user who took the reading
  final String? notes;
  final List<String>? photos; // photos of the meter

  const ConsumptionReading({
    required this.id,
    required this.condominium,
    required this.unit,
    required this.meterType,
    required this.reading,
    required this.readingDate,
    required this.readBy,
    this.notes,
    this.photos,
  });

  factory ConsumptionReading.fromJson(Map<String, dynamic> json) => _$ConsumptionReadingFromJson(json);
  Map<String, dynamic> toJson() => _$ConsumptionReadingToJson(this);
}

@JsonSerializable()
class ConsumptionData {
  final String unit;
  final String meterType;
  final List<MonthlyConsumption> monthlyData;
  final double averageConsumption;
  final double lastReading;
  final DateTime lastReadingDate;

  const ConsumptionData({
    required this.unit,
    required this.meterType,
    required this.monthlyData,
    required this.averageConsumption,
    required this.lastReading,
    required this.lastReadingDate,
  });

  factory ConsumptionData.fromJson(Map<String, dynamic> json) => _$ConsumptionDataFromJson(json);
  Map<String, dynamic> toJson() => _$ConsumptionDataToJson(this);
}

@JsonSerializable()
class MonthlyConsumption {
  final String month;
  final double consumption;
  final double cost;

  const MonthlyConsumption({
    required this.month,
    required this.consumption,
    required this.cost,
  });

  factory MonthlyConsumption.fromJson(Map<String, dynamic> json) => _$MonthlyConsumptionFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyConsumptionToJson(this);
}