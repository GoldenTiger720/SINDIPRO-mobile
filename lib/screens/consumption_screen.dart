import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedBuilding;
  DateTime _selectedDate = DateTime.now();

  final List<String> _buildings = ['All Buildings', 'Edifício Alpha', 'Condomínio Beta', 'Residencial Gamma'];

  // Mock data for consumption entries
  final List<Map<String, dynamic>> _consumptionEntries = [
    {
      'id': '1',
      'building': 'Edifício Alpha',
      'unit': '101',
      'utilityType': 'water',
      'reading': 1250.5,
      'previousReading': 1180.0,
      'consumption': 70.5,
      'date': DateTime(2024, 12, 1),
      'cost': 142.50,
      'alert': false,
    },
    {
      'id': '2',
      'building': 'Edifício Alpha',
      'unit': '102',
      'utilityType': 'electricity',
      'reading': 2850.0,
      'previousReading': 2520.0,
      'consumption': 330.0,
      'date': DateTime(2024, 12, 1),
      'cost': 198.00,
      'alert': true, // >10% increase
    },
    {
      'id': '3',
      'building': 'Condomínio Beta',
      'unit': '201',
      'utilityType': 'gas',
      'reading': 450.2,
      'previousReading': 425.8,
      'consumption': 24.4,
      'date': DateTime(2024, 12, 1),
      'cost': 75.60,
      'alert': false,
    },
    {
      'id': '4',
      'building': 'Residencial Gamma',
      'unit': '301',
      'utilityType': 'water',
      'reading': 980.0,
      'previousReading': 850.0,
      'consumption': 130.0,
      'date': DateTime(2024, 12, 1),
      'cost': 260.00,
      'alert': true, // >10% increase
    },
  ];

  // Mock data for monthly bills
  final List<Map<String, dynamic>> _monthlyBills = [
    {
      'building': 'Edifício Alpha',
      'month': 'December 2024',
      'totalWater': 2450.75,
      'totalElectricity': 8920.50,
      'totalGas': 1250.30,
      'totalCost': 12621.55,
      'units': 12,
      'paid': true,
    },
    {
      'building': 'Condomínio Beta',
      'month': 'December 2024',
      'totalWater': 1850.25,
      'totalElectricity': 6750.80,
      'totalGas': 980.60,
      'totalCost': 9581.65,
      'units': 8,
      'paid': false,
    },
    {
      'building': 'Residencial Gamma',
      'month': 'December 2024',
      'totalWater': 3200.90,
      'totalElectricity': 11500.25,
      'totalGas': 1680.45,
      'totalCost': 16381.60,
      'units': 16,
      'paid': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedBuilding = 'All Buildings';
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
                const Icon(Icons.water_drop, color: Color(0xFF06B6D4)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    languageProvider.consumptionManagement,
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
              labelColor: const Color(0xFF06B6D4),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF06B6D4),
              tabs: [
                Tab(
                  icon: const Icon(Icons.input),
                  text: 'Consumption',
                ),
                Tab(
                  icon: const Icon(Icons.receipt_long),
                  text: 'Account',
                ),
                Tab(
                  icon: const Icon(Icons.analytics),
                  text: 'Graphics',
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Building Filter
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.apartment, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedBuilding,
                        decoration: InputDecoration(
                          labelText: 'Building',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _buildings.map((building) {
                          return DropdownMenuItem(
                            value: building,
                            child: Text(building),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBuilding = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildConsumptionTab(languageProvider),
                    _buildAccountTab(languageProvider),
                    _buildGraphicsTab(languageProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConsumptionTab(LanguageProvider languageProvider) {
    final alertCount = _consumptionEntries.where((entry) => entry['alert'] == true).length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alert Summary
          if (alertCount > 0)
            Card(
              color: const Color(0xFFFEF2F2),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Color(0xFFEF4444)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'High Consumption Alert',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                          Text(
                            '$alertCount units have >10% consumption increase',
                            style: const TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Units',
                  '${_consumptionEntries.length}',
                  Icons.home,
                  const Color(0xFF06B6D4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Alerts',
                  '$alertCount',
                  Icons.warning,
                  const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Date Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Consumption Entry',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(_formatDate(_selectedDate)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add Entry Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddConsumptionDialog(languageProvider),
              icon: const Icon(Icons.add),
              label: const Text('Add New Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Consumption Entries List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _consumptionEntries.length,
            itemBuilder: (context, index) {
              final entry = _consumptionEntries[index];
              return _buildConsumptionCard(entry, languageProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Buildings',
                  '${_monthlyBills.length}',
                  const Color(0xFF06B6D4),
                  Icons.apartment,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total Units',
                  '${_monthlyBills.fold<int>(0, (sum, bill) => sum + (bill['units'] as int))}',
                  const Color(0xFF16A34A),
                  Icons.home,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Total Monthly Cost',
            _monthlyBills.fold<double>(0, (sum, bill) => sum + bill['totalCost']),
            const Color(0xFFF97316),
            Icons.payments,
          ),
          const SizedBox(height: 24),
          // Add Bill Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Bills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddBillDialog(languageProvider),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Bill'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Monthly Bills List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _monthlyBills.length,
            itemBuilder: (context, index) {
              final bill = _monthlyBills[index];
              return _buildBillCard(bill, languageProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicsTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consumption Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Utility Distribution Cards
          Row(
            children: [
              Expanded(
                child: _buildUtilityCard(
                  'Water',
                  '2,450 L',
                  const Color(0xFF06B6D4),
                  Icons.water_drop,
                  '35%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildUtilityCard(
                  'Electricity',
                  '8,920 kWh',
                  const Color(0xFFEAB308),
                  Icons.flash_on,
                  '50%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildUtilityCard(
            'Gas',
            '1,250 m³',
            const Color(0xFFF97316),
            Icons.local_gas_station,
            '15%',
          ),
          const SizedBox(height: 24),
          // Charts Placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Consumption Trend',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart, size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Chart visualization will be displayed here',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Export Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Export Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Export to PDF
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Export PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Export to Excel
                          },
                          icon: const Icon(Icons.file_download),
                          label: const Text('Export Excel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, dynamic value, Color color, IconData icon) {
    String displayValue;
    if (value is double) {
      displayValue = 'R\$ ${_formatCurrency(value)}';
    } else {
      displayValue = value.toString();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityCard(String title, String value, Color color, IconData icon, String percentage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Text(
                  percentage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
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
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionCard(Map<String, dynamic> entry, LanguageProvider languageProvider) {
    final utilityConfig = _getUtilityConfig(entry['utilityType']);
    final hasAlert = entry['alert'] == true;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: utilityConfig['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            utilityConfig['icon'],
            color: utilityConfig['color'],
          ),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                '${entry['building']} - Unit ${entry['unit']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasAlert) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ALERT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${utilityConfig['label']} • ${_formatDate(entry['date'])}',
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Current: ${entry['reading']} ${utilityConfig['unit']} • Consumption: ${entry['consumption']} ${utilityConfig['unit']}',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$ ${entry['cost'].toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: utilityConfig['color'],
              ),
            ),
            if (hasAlert)
              const Icon(
                Icons.trending_up,
                size: 16,
                color: Color(0xFFEF4444),
              ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill, LanguageProvider languageProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: bill['paid'] 
              ? const Color(0xFF16A34A).withOpacity(0.1)
              : const Color(0xFFEF4444).withOpacity(0.1),
          child: Icon(
            bill['paid'] ? Icons.check_circle : Icons.pending,
            color: bill['paid'] ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
          ),
        ),
        title: Text(
          bill['building'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${bill['month']} • ${bill['units']} units'),
        trailing: Text(
          'R\$ ${_formatCurrency(bill['totalCost'])}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBillRow('Water:', 'R\$ ${_formatCurrency(bill['totalWater'])}', const Color(0xFF06B6D4)),
                _buildBillRow('Electricity:', 'R\$ ${_formatCurrency(bill['totalElectricity'])}', const Color(0xFFEAB308)),
                _buildBillRow('Gas:', 'R\$ ${_formatCurrency(bill['totalGas'])}', const Color(0xFFF97316)),
                const Divider(),
                _buildBillRow('Total:', 'R\$ ${_formatCurrency(bill['totalCost'])}', Colors.black, isBold: true),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: View details
                        },
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: bill['paid'] ? null : () {
                          // TODO: Mark as paid
                        },
                        icon: Icon(
                          bill['paid'] ? Icons.check : Icons.payment,
                          size: 16,
                        ),
                        label: Text(bill['paid'] ? 'Paid' : 'Mark Paid'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bill['paid'] 
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF06B6D4),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getUtilityConfig(String utilityType) {
    switch (utilityType) {
      case 'water':
        return {
          'label': 'Water',
          'icon': Icons.water_drop,
          'color': const Color(0xFF06B6D4),
          'unit': 'L',
        };
      case 'electricity':
        return {
          'label': 'Electricity',
          'icon': Icons.flash_on,
          'color': const Color(0xFFEAB308),
          'unit': 'kWh',
        };
      case 'gas':
        return {
          'label': 'Gas',
          'icon': Icons.local_gas_station,
          'color': const Color(0xFFF97316),
          'unit': 'm³',
        };
      default:
        return {
          'label': 'Other',
          'icon': Icons.device_unknown,
          'color': Colors.grey,
          'unit': 'units',
        };
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return value.toStringAsFixed(2);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showAddConsumptionDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Consumption Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Building',
                  border: OutlineInputBorder(),
                ),
                items: _buildings.skip(1).map((building) {
                  return DropdownMenuItem(
                    value: building,
                    child: Text(building),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Unit Number',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 101',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Utility Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'water', child: Text('Water')),
                  DropdownMenuItem(value: 'electricity', child: Text('Electricity')),
                  DropdownMenuItem(value: 'gas', child: Text('Gas')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Current Reading',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Previous Reading',
                  border: OutlineInputBorder(),
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
              // TODO: Implement add consumption
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }

  void _showAddBillDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Monthly Bill'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Building',
                  border: OutlineInputBorder(),
                ),
                items: _buildings.skip(1).map((building) {
                  return DropdownMenuItem(
                    value: building,
                    child: Text(building),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Month/Year',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., December 2024',
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Water Cost',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Electricity Cost',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Gas Cost',
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
              // TODO: Implement add bill
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }
}