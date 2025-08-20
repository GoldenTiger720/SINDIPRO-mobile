import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = true;
  String? _selectedCondominium;

  // Mock data matching web version
  final List<String> _condominiums = ['All', 'Edifício Alpha', 'Condomínio Beta', 'Residencial Gamma'];
  
  final List<Map<String, dynamic>> _equipment = [
    {
      'id': '1',
      'name': 'Elevador Principal',
      'type': 'Elevator',
      'location': 'Torre A - Hall Principal',
      'condominium': 'Edifício Alpha',
      'status': 'operational',
      'contractorName': 'ElevaTech Ltda.',
      'contractorPhone': '(11) 3456-7890',
      'purchaseDate': DateTime(2020, 3, 15),
      'maintenanceFrequency': 'monthly',
      'lastMaintenance': DateTime(2024, 11, 15),
      'nextMaintenance': DateTime(2024, 12, 15),
      'maintenanceCount': 45,
    },
    {
      'id': '2',
      'name': 'Gerador de Emergência',
      'type': 'Generator',
      'location': 'Subsolo',
      'condominium': 'Edifício Alpha',
      'status': 'maintenance',
      'contractorName': 'PowerGen Manutenção',
      'contractorPhone': '(11) 3210-9876',
      'purchaseDate': DateTime(2019, 7, 22),
      'maintenanceFrequency': 'quarterly',
      'lastMaintenance': DateTime(2024, 10, 1),
      'nextMaintenance': DateTime(2024, 12, 1),
      'maintenanceCount': 18,
    },
    {
      'id': '3',
      'name': 'Sistema de Alarme',
      'type': 'Security',
      'location': 'Central de Monitoramento',
      'condominium': 'Condomínio Beta',
      'status': 'operational',
      'contractorName': 'SecurMax Segurança',
      'contractorPhone': '(11) 9876-5432',
      'purchaseDate': DateTime(2021, 5, 10),
      'maintenanceFrequency': 'semiannual',
      'lastMaintenance': DateTime(2024, 6, 10),
      'nextMaintenance': DateTime(2024, 12, 10),
      'maintenanceCount': 6,
    },
  ];

  final List<Map<String, dynamic>> _maintenanceSchedule = [
    {
      'equipmentName': 'Elevador Principal',
      'type': 'Preventive',
      'date': DateTime(2024, 12, 15),
      'contractor': 'ElevaTech Ltda.',
      'urgency': 'normal',
    },
    {
      'equipmentName': 'Gerador de Emergência',
      'type': 'Corrective',
      'date': DateTime(2024, 12, 1),
      'contractor': 'PowerGen Manutenção',
      'urgency': 'urgent',
    },
    {
      'equipmentName': 'Sistema de Alarme',
      'type': 'Preventive',
      'date': DateTime(2024, 12, 10),
      'contractor': 'SecurMax Segurança',
      'urgency': 'normal',
    },
  ];

  final List<Map<String, dynamic>> _maintenanceHistory = [
    {
      'equipmentName': 'Elevador Principal',
      'date': DateTime(2024, 11, 15),
      'type': 'Preventive',
      'description': 'Manutenção preventiva mensal - lubrificação e ajustes',
      'technician': 'Carlos Silva',
      'cost': 450.0,
      'notes': 'Equipamento funcionando normalmente',
    },
    {
      'equipmentName': 'Gerador de Emergência',
      'date': DateTime(2024, 10, 1),
      'type': 'Corrective',
      'description': 'Troca do filtro de óleo e verificação do sistema',
      'technician': 'Fernando Rocha',
      'cost': 280.0,
      'notes': 'Identificado vazamento pequeno, corrigido',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedCondominium = 'All';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Row(
              children: [
                const Icon(Icons.build, color: Color(0xFF22c55e)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    languageProvider.equipmentMaintenance,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
            bottom: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF22c55e),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF22c55e),
              tabs: [
                Tab(
                  icon: const Icon(Icons.list),
                  text: languageProvider.equipmentList,
                ),
                Tab(
                  icon: const Icon(Icons.schedule),
                  text: languageProvider.maintenanceSchedule,
                ),
                Tab(
                  icon: const Icon(Icons.history),
                  text: languageProvider.maintenanceHistory,
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Statistics Cards
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Condominium Filter
                    Row(
                      children: [
                        const Icon(Icons.filter_list, color: Color(0xFF6B7280)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCondominium,
                            decoration: InputDecoration(
                              labelText: languageProvider.condominium,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _condominiums.map((condominium) {
                              return DropdownMenuItem(
                                value: condominium,
                                child: Text(condominium),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCondominium = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            languageProvider.totalEquipment,
                            '${_equipment.length}',
                            Icons.build,
                            const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            languageProvider.operational,
                            '${_equipment.where((e) => e['status'] == 'operational').length}',
                            Icons.check_circle,
                            const Color(0xFF22c55e),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            languageProvider.underMaintenance,
                            '${_equipment.where((e) => e['status'] == 'maintenance').length}',
                            Icons.engineering,
                            const Color(0xFFEAB308),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildStatCard(
                            'Scheduled This Month',
                            '${_maintenanceSchedule.length}',
                            Icons.event,
                            const Color(0xFF3b82f6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildEquipmentListTab(languageProvider),
                    _buildMaintenanceScheduleTab(languageProvider),
                    _buildMaintenanceHistoryTab(languageProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentListTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // View Toggle and Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // View Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.grid_view, color: _isGridView ? const Color(0xFF22c55e) : Colors.grey),
                      onPressed: () => setState(() => _isGridView = true),
                    ),
                    IconButton(
                      icon: Icon(Icons.list, color: !_isGridView ? const Color(0xFF22c55e) : Colors.grey),
                      onPressed: () => setState(() => _isGridView = false),
                    ),
                  ],
                ),
              ),
              // Add Equipment Button
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddEquipmentDialog(languageProvider),
                  icon: const Icon(Icons.add),
                  label: Text(languageProvider.addEquipment),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22c55e),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Equipment List
          _isGridView ? _buildEquipmentGrid(languageProvider) : _buildEquipmentList(languageProvider),
        ],
      ),
    );
  }

  Widget _buildEquipmentGrid(LanguageProvider languageProvider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: _equipment.length,
      itemBuilder: (context, index) {
        final equipment = _equipment[index];
        return _buildEquipmentCard(equipment, languageProvider);
      },
    );
  }

  Widget _buildEquipmentList(LanguageProvider languageProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _equipment.length,
      itemBuilder: (context, index) {
        final equipment = _equipment[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(equipment['status']).withOpacity(0.1),
              child: Icon(
                _getEquipmentIcon(equipment['type']),
                color: _getStatusColor(equipment['status']),
              ),
            ),
            title: Text(
              equipment['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${equipment['type']} • ${equipment['location']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusBadge(equipment['status']),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Maintenance: ${equipment['maintenanceCount']}',
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => _showAddMaintenanceDialog(equipment, languageProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22c55e),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 30),
                ),
                child: Text(
                  languageProvider.addMaintenance,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildEquipmentCard(Map<String, dynamic> equipment, LanguageProvider languageProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Equipment Header
            Row(
              children: [
                Icon(
                  _getEquipmentIcon(equipment['type']),
                  color: _getStatusColor(equipment['status']),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    equipment['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Status Badge
            _buildStatusBadge(equipment['status']),
            const SizedBox(height: 8),
            // Details
            Text(
              equipment['type'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              equipment['location'],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Next: ${_formatDate(equipment['nextMaintenance'])}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Add Maintenance Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showAddMaintenanceDialog(equipment, languageProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22c55e),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  minimumSize: const Size(0, 32),
                ),
                child: Text(
                  languageProvider.addMaintenance,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceScheduleTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Maintenance - Next 30 Days',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _maintenanceSchedule.length,
            itemBuilder: (context, index) {
              final maintenance = _maintenanceSchedule[index];
              final urgencyColor = _getUrgencyColor(maintenance['urgency']);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: urgencyColor.withOpacity(0.1),
                    child: Icon(
                      Icons.schedule,
                      color: urgencyColor,
                    ),
                  ),
                  title: Text(
                    maintenance['equipmentName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${maintenance['type']} • ${maintenance['contractor']}'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(maintenance['date']),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: urgencyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      maintenance['urgency'] == 'urgent' ? 'Urgent' : 'Normal',
                      style: TextStyle(
                        fontSize: 10,
                        color: urgencyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceHistoryTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageProvider.maintenanceHistory,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _maintenanceHistory.length,
            itemBuilder: (context, index) {
              final history = _maintenanceHistory[index];
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF22c55e).withOpacity(0.1),
                    child: const Icon(
                      Icons.history,
                      color: Color(0xFF22c55e),
                    ),
                  ),
                  title: Text(
                    history['equipmentName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${_formatDate(history['date'])} • ${history['type']}',
                  ),
                  trailing: Text(
                    'R\$ ${history['cost'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22c55e),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHistoryRow('Description:', history['description']),
                          _buildHistoryRow('Technician:', history['technician']),
                          _buildHistoryRow('Cost:', 'R\$ ${history['cost'].toStringAsFixed(2)}'),
                          if (history['notes'] != null)
                            _buildHistoryRow('Notes:', history['notes']),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusConfig = _getStatusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusConfig['label'],
        style: TextStyle(
          fontSize: 10,
          color: statusConfig['color'],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    switch (status) {
      case 'operational':
        return {'label': 'Operating', 'color': const Color(0xFF22c55e)};
      case 'maintenance':
        return {'label': 'Maintenance', 'color': const Color(0xFFEAB308)};
      case 'repair':
        return {'label': 'Repair', 'color': const Color(0xFFF97316)};
      case 'inactive':
        return {'label': 'Inactive', 'color': const Color(0xFFEF4444)};
      default:
        return {'label': 'Unknown', 'color': Colors.grey};
    }
  }

  Color _getStatusColor(String status) {
    return _getStatusConfig(status)['color'];
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'urgent':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getEquipmentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'elevator':
        return Icons.elevator;
      case 'generator':
        return Icons.power;
      case 'security':
        return Icons.security;
      case 'pump':
        return Icons.water_drop;
      case 'hvac':
        return Icons.air;
      default:
        return Icons.build;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showAddEquipmentDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.addEquipment),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Equipment Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Equipment Type',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: languageProvider.location,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: languageProvider.condominium,
                  border: const OutlineInputBorder(),
                ),
                items: _condominiums.skip(1).map((condominium) {
                  return DropdownMenuItem(
                    value: condominium,
                    child: Text(condominium),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Purchase Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Maintenance Frequency',
                  border: const OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
                  DropdownMenuItem(value: 'semiannual', child: Text('Semiannual')),
                  DropdownMenuItem(value: 'annual', child: Text('Annual')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(languageProvider.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add equipment
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22c55e),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }

  void _showAddMaintenanceDialog(Map<String, dynamic> equipment, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${languageProvider.addMaintenance} - ${equipment['name']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(text: _formatDate(DateTime.now())),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Maintenance Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'preventive', child: Text('Preventive')),
                  DropdownMenuItem(value: 'corrective', child: Text('Corrective')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: languageProvider.description,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Technician',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cost (Optional)',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(languageProvider.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add maintenance
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22c55e),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }
}