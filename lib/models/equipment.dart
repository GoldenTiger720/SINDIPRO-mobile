import 'package:json_annotation/json_annotation.dart';

part 'equipment.g.dart';

@JsonSerializable()
class Equipment {
  final String id;
  final String name;
  final String type;
  final String location;
  final DateTime purchaseDate;
  final String contractorName;
  final String contractorPhone;
  final String maintenanceFrequency;
  final DateTime? lastMaintenance;
  final DateTime? nextMaintenance;
  final String status; // 'operational', 'maintenance', 'repair', 'inactive'
  final String condominium;
  final List<MaintenanceRecord> maintenanceHistory;

  const Equipment({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.purchaseDate,
    required this.contractorName,
    required this.contractorPhone,
    required this.maintenanceFrequency,
    this.lastMaintenance,
    this.nextMaintenance,
    required this.status,
    required this.condominium,
    required this.maintenanceHistory,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => _$EquipmentFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentToJson(this);

  bool get isOperational => status == 'operational';
  bool get needsMaintenance => status == 'maintenance';
  bool get needsRepair => status == 'repair';
  bool get isInactive => status == 'inactive';
}

@JsonSerializable()
class MaintenanceRecord {
  final String id;
  final DateTime date;
  final String type;
  final String description;
  final String technician;
  final double? cost;
  final String? notes;
  final List<String>? photos;

  const MaintenanceRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.technician,
    this.cost,
    this.notes,
    this.photos,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) => _$MaintenanceRecordFromJson(json);
  Map<String, dynamic> toJson() => _$MaintenanceRecordToJson(this);
}