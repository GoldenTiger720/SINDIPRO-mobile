// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Equipment _$EquipmentFromJson(Map<String, dynamic> json) => Equipment(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  location: json['location'] as String,
  purchaseDate: DateTime.parse(json['purchaseDate'] as String),
  contractorName: json['contractorName'] as String,
  contractorPhone: json['contractorPhone'] as String,
  maintenanceFrequency: json['maintenanceFrequency'] as String,
  lastMaintenance: json['lastMaintenance'] == null
      ? null
      : DateTime.parse(json['lastMaintenance'] as String),
  nextMaintenance: json['nextMaintenance'] == null
      ? null
      : DateTime.parse(json['nextMaintenance'] as String),
  status: json['status'] as String,
  condominium: json['condominium'] as String,
  maintenanceHistory: (json['maintenanceHistory'] as List<dynamic>)
      .map((e) => MaintenanceRecord.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EquipmentToJson(Equipment instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'location': instance.location,
  'purchaseDate': instance.purchaseDate.toIso8601String(),
  'contractorName': instance.contractorName,
  'contractorPhone': instance.contractorPhone,
  'maintenanceFrequency': instance.maintenanceFrequency,
  'lastMaintenance': instance.lastMaintenance?.toIso8601String(),
  'nextMaintenance': instance.nextMaintenance?.toIso8601String(),
  'status': instance.status,
  'condominium': instance.condominium,
  'maintenanceHistory': instance.maintenanceHistory,
};

MaintenanceRecord _$MaintenanceRecordFromJson(Map<String, dynamic> json) =>
    MaintenanceRecord(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      description: json['description'] as String,
      technician: json['technician'] as String,
      cost: (json['cost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MaintenanceRecordToJson(MaintenanceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'type': instance.type,
      'description': instance.description,
      'technician': instance.technician,
      'cost': instance.cost,
      'notes': instance.notes,
      'photos': instance.photos,
    };
