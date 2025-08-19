import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../models/equipment.dart';
import '../services/api_service.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final ApiService _apiService = ApiService();
  List<Equipment> _equipment = [];
  bool _isLoading = true;
  String? _selectedCondominium;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  Future<void> _loadEquipment() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      
      String? condominiumFilter;
      if (user?.isCaretaker == true) {
        condominiumFilter = user?.condominium;
        _selectedCondominium = user?.condominium;
      }

      final equipment = await _apiService.getEquipment(condominiumFilter);
      
      setState(() {
        _equipment = equipment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading equipment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Equipment & Maintenance'),
            actions: [
              if (user.isManager)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddEquipmentDialog(),
                ),
            ],
          ),
          body: Column(
            children: [
              // Condominium Filter for Managers
              if (user.isManager)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCondominium,
                    decoration: const InputDecoration(
                      labelText: 'Select Condominium',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Condominiums'),
                      ),
                      ...authProvider.getAccessibleCondominiums().map(
                        (condo) => DropdownMenuItem<String>(
                          value: condo,
                          child: Text(condo),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCondominium = value;
                      });
                      _loadEquipment();
                    },
                  ),
                ),

              // Equipment List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _equipment.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.build,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No equipment found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _equipment.length,
                            itemBuilder: (context, index) {
                              final equipment = _equipment[index];
                              return _buildEquipmentCard(equipment);
                            },
                          ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddMaintenanceDialog(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildEquipmentCard(Equipment equipment) {
    Color statusColor;
    switch (equipment.status) {
      case 'operational':
        statusColor = Colors.green;
        break;
      case 'maintenance':
        statusColor = Colors.orange;
        break;
      case 'repair':
        statusColor = Colors.red;
        break;
      case 'inactive':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.build,
                  color: statusColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    equipment.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    equipment.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.category, 'Type', equipment.type),
            _buildInfoRow(Icons.location_on, 'Location', equipment.location),
            _buildInfoRow(Icons.apartment, 'Building', equipment.condominium),
            _buildInfoRow(Icons.phone, 'Contractor', equipment.contractorPhone),
            if (equipment.nextMaintenance != null)
              _buildInfoRow(
                Icons.schedule,
                'Next Maintenance',
                _formatDate(equipment.nextMaintenance!),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showMaintenanceHistory(equipment),
                    icon: const Icon(Icons.history, size: 16),
                    label: const Text('History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addMaintenanceRecord(equipment),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Record'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddEquipmentDialog() {
    // Implementation for adding new equipment
    showDialog(
      context: context,
      builder: (context) => const AddEquipmentDialog(),
    );
  }

  void _showAddMaintenanceDialog() {
    // Show equipment selection dialog first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Equipment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _equipment.map((eq) => ListTile(
            title: Text(eq.name),
            subtitle: Text('${eq.condominium} - ${eq.location}'),
            onTap: () {
              Navigator.pop(context);
              _addMaintenanceRecord(eq);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _addMaintenanceRecord(Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => AddMaintenanceDialog(equipment: equipment),
    );
  }

  void _showMaintenanceHistory(Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => MaintenanceHistoryDialog(equipment: equipment),
    );
  }
}

class AddEquipmentDialog extends StatelessWidget {
  const AddEquipmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Equipment'),
      content: const Text('Equipment addition form would go here'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class AddMaintenanceDialog extends StatefulWidget {
  final Equipment equipment;

  const AddMaintenanceDialog({super.key, required this.equipment});

  @override
  State<AddMaintenanceDialog> createState() => _AddMaintenanceDialogState();
}

class _AddMaintenanceDialogState extends State<AddMaintenanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _technicianController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  String _maintenanceType = 'Preventive Maintenance';
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Add Maintenance Record'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Equipment: ${widget.equipment.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _maintenanceType,
                        decoration: const InputDecoration(
                          labelText: 'Maintenance Type',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Preventive Maintenance',
                            child: Text('Preventive Maintenance'),
                          ),
                          DropdownMenuItem(
                            value: 'Corrective Maintenance',
                            child: Text('Corrective Maintenance'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _maintenanceType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Describe the maintenance performed...',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _technicianController,
                        decoration: const InputDecoration(
                          labelText: 'Technician Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter technician name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(
                          labelText: 'Cost (R\$)',
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Additional Notes',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Photo section
                      Row(
                        children: [
                          const Text(
                            'Photos:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.camera_alt, size: 16),
                            label: const Text('Add Photos'),
                          ),
                        ],
                      ),
                      if (_selectedImages.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _selectedImages[index],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitMaintenanceRecord,
                      child: const Text('Save Record'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _selectedImages.addAll(pickedFiles.map((xFile) => File(xFile.path)));
    });
  }

  void _submitMaintenanceRecord() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit maintenance record to API
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maintenance record added successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _technicianController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class MaintenanceHistoryDialog extends StatelessWidget {
  final Equipment equipment;

  const MaintenanceHistoryDialog({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          children: [
            AppBar(
              title: const Text('Maintenance History'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: equipment.maintenanceHistory.isEmpty
                  ? const Center(
                      child: Text('No maintenance records yet'),
                    )
                  : ListView.builder(
                      itemCount: equipment.maintenanceHistory.length,
                      itemBuilder: (context, index) {
                        final record = equipment.maintenanceHistory[index];
                        return ListTile(
                          leading: Icon(
                            record.type.contains('Preventive')
                                ? Icons.schedule
                                : Icons.build,
                          ),
                          title: Text(record.description),
                          subtitle: Text(
                            'Technician: ${record.technician}\n'
                            'Date: ${record.date.day}/${record.date.month}/${record.date.year}',
                          ),
                          trailing: record.cost != null
                              ? Text(
                                  'R\$ ${record.cost!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}