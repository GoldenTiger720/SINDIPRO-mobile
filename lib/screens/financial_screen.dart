import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedBuilding;

  final List<String> _buildings = ['All Buildings', 'Edifício Alpha', 'Condomínio Beta', 'Residencial Gamma'];

  // Mock data for budget accounts
  final List<Map<String, dynamic>> _budgetAccounts = [
    {
      'code': '1000',
      'name': 'Maintenance and Repairs',
      'type': 'main',
      'expected': 15000.0,
      'actual': 12500.0,
      'children': [
        {'code': '1001', 'name': 'Elevator Maintenance', 'expected': 5000.0, 'actual': 4800.0},
        {'code': '1002', 'name': 'Plumbing Repairs', 'expected': 3000.0, 'actual': 2700.0},
        {'code': '1003', 'name': 'Electrical Repairs', 'expected': 4000.0, 'actual': 3500.0},
      ],
    },
    {
      'code': '2000',
      'name': 'Administrative Expenses',
      'type': 'main',
      'expected': 8000.0,
      'actual': 7200.0,
      'children': [
        {'code': '2001', 'name': 'Office Supplies', 'expected': 2000.0, 'actual': 1800.0},
        {'code': '2002', 'name': 'Professional Services', 'expected': 6000.0, 'actual': 5400.0},
      ],
    },
    {
      'code': '3000',
      'name': 'Utilities',
      'type': 'main',
      'expected': 12000.0,
      'actual': 13500.0,
      'children': [
        {'code': '3001', 'name': 'Electricity', 'expected': 7000.0, 'actual': 8200.0},
        {'code': '3002', 'name': 'Water', 'expected': 3000.0, 'actual': 3100.0},
        {'code': '3003', 'name': 'Gas', 'expected': 2000.0, 'actual': 2200.0},
      ],
    },
  ];

  // Mock data for collection accounts
  final List<Map<String, dynamic>> _collectionAccounts = [
    {
      'name': 'Monthly Condominium Fee',
      'purpose': 'Operating expenses and maintenance',
      'monthlyAmount': 450.0,
      'startDate': DateTime(2024, 1, 1),
      'isActive': true,
    },
    {
      'name': 'Reserve Fund',
      'purpose': 'Emergency repairs and improvements',
      'monthlyAmount': 150.0,
      'startDate': DateTime(2024, 1, 1),
      'isActive': true,
    },
    {
      'name': 'Special Assessment - Pool',
      'purpose': 'Pool renovation project',
      'monthlyAmount': 200.0,
      'startDate': DateTime(2024, 6, 1),
      'isActive': false,
    },
  ];

  // Mock data for unit market values
  final List<Map<String, dynamic>> _unitValues = [
    {
      'unit': '101',
      'area': 85.5,
      'condominiumPerM2': 5.26,
      'rentalPerM2': 35.0,
      'salePerM2': 8500.0,
      'totalSaleValue': 726750.0,
    },
    {
      'unit': '102',
      'area': 75.0,
      'condominiumPerM2': 6.00,
      'rentalPerM2': 40.0,
      'salePerM2': 9000.0,
      'totalSaleValue': 675000.0,
    },
    {
      'unit': '201',
      'area': 95.0,
      'condominiumPerM2': 4.74,
      'rentalPerM2': 32.0,
      'salePerM2': 8200.0,
      'totalSaleValue': 779000.0,
    },
    {
      'unit': '202',
      'area': 88.0,
      'condominiumPerM2': 5.11,
      'rentalPerM2': 38.0,
      'salePerM2': 8800.0,
      'totalSaleValue': 774400.0,
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
                const Icon(Icons.bar_chart, color: Color(0xFFF97316)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    languageProvider.financialManagement,
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
              labelColor: const Color(0xFFF97316),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFF97316),
              tabs: [
                Tab(
                  icon: const Icon(Icons.account_balance),
                  text: 'Budget Management',
                ),
                Tab(
                  icon: const Icon(Icons.calculate),
                  text: 'Calculations',
                ),
                Tab(
                  icon: const Icon(Icons.trending_up),
                  text: 'Market Values',
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
                    _buildBudgetManagementTab(languageProvider),
                    _buildCondominiumCalculationsTab(languageProvider),
                    _buildMarketValuesTab(languageProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBudgetManagementTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Budget',
                  _budgetAccounts.fold<double>(0, (sum, account) => sum + account['expected']),
                  const Color(0xFF2563EB),
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total Spent',
                  _budgetAccounts.fold<double>(0, (sum, account) => sum + account['actual']),
                  const Color(0xFFF97316),
                  Icons.payments,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Remaining',
                  _budgetAccounts.fold<double>(0, (sum, account) => sum + (account['expected'] - account['actual'])),
                  const Color(0xFF16A34A),
                  Icons.savings,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Variance',
                  _budgetAccounts.fold<double>(0, (sum, account) => sum + (account['actual'] - account['expected'])),
                  const Color(0xFFDC2626),
                  Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Add Account Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chart of Accounts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddAccountDialog(languageProvider),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF97316),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart of Accounts
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _budgetAccounts.length,
            itemBuilder: (context, index) {
              final account = _budgetAccounts[index];
              return _buildAccountCard(account, languageProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCondominiumCalculationsTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Collection Account Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Collection Accounts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddCollectionDialog(languageProvider),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Collection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF97316),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Collection Accounts List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _collectionAccounts.length,
            itemBuilder: (context, index) {
              final collection = _collectionAccounts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: collection['isActive'] 
                        ? const Color(0xFF16A34A).withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    child: Icon(
                      Icons.account_circle,
                      color: collection['isActive'] 
                          ? const Color(0xFF16A34A)
                          : Colors.grey,
                    ),
                  ),
                  title: Text(
                    collection['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(collection['purpose']),
                      const SizedBox(height: 4),
                      Text(
                        'R\$ ${collection['monthlyAmount'].toStringAsFixed(2)}/month',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF97316),
                        ),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: collection['isActive'] 
                          ? const Color(0xFF16A34A).withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      collection['isActive'] ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        color: collection['isActive'] 
                            ? const Color(0xFF16A34A)
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          // Expense Distribution Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Total Expense Amount',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Distribution Method',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'area', child: Text('By Unit Area')),
                      DropdownMenuItem(value: 'equal', child: Text('Equal Distribution')),
                      DropdownMenuItem(value: 'custom', child: Text('Custom Percentage')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement distribution calculation
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Calculate Distribution'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketValuesTab(LanguageProvider languageProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Market Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Avg. Sale Price',
                  _unitValues.fold<double>(0, (sum, unit) => sum + unit['salePerM2']) / _unitValues.length,
                  const Color(0xFF2563EB),
                  Icons.sell,
                  suffix: '/m²',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Avg. Rental Price',
                  _unitValues.fold<double>(0, (sum, unit) => sum + unit['rentalPerM2']) / _unitValues.length,
                  const Color(0xFF16A34A),
                  Icons.home,
                  suffix: '/m²',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Total Building Value',
            _unitValues.fold<double>(0, (sum, unit) => sum + unit['totalSaleValue']),
            const Color(0xFFF97316),
            Icons.account_balance,
          ),
          const SizedBox(height: 24),
          const Text(
            'Unit Market Analysis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Units Market Values Table
          Card(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 1, child: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Area (m²)', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Sale/m²', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Total Value', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _unitValues.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final unit = _unitValues[index];
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              unit['unit'],
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('${unit['area'].toStringAsFixed(1)} m²'),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'R\$ ${unit['salePerM2'].toStringAsFixed(0)}',
                              style: const TextStyle(color: Color(0xFF2563EB)),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'R\$ ${_formatCurrency(unit['totalSaleValue'])}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF97316),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Export Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement export functionality
              },
              icon: const Icon(Icons.file_download),
              label: const Text('Export Market Analysis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double value, Color color, IconData icon, {String suffix = ''}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              suffix.isNotEmpty 
                  ? 'R\$ ${value.toStringAsFixed(0)}$suffix'
                  : 'R\$ ${_formatCurrency(value)}',
              style: TextStyle(
                fontSize: 16,
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(Map<String, dynamic> account, LanguageProvider languageProvider) {
    final variance = account['actual'] - account['expected'];
    final isOverBudget = variance > 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF97316).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            account['code'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFF97316),
            ),
          ),
        ),
        title: Text(
          account['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Budget: R\$ ${_formatCurrency(account['expected'])}'),
            Text(
              'Variance: R\$ ${variance.toStringAsFixed(0)}',
              style: TextStyle(
                color: isOverBudget ? Colors.red : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Text(
          'R\$ ${_formatCurrency(account['actual'])}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          if (account['children'] != null)
            ...account['children'].map<Widget>((child) {
              final childVariance = child['actual'] - child['expected'];
              final isChildOverBudget = childVariance > 0;
              
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 32, right: 16),
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    child['code'],
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(child['name']),
                subtitle: Text('Budget: R\$ ${_formatCurrency(child['expected'])}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'R\$ ${_formatCurrency(child['actual'])}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R\$ ${childVariance.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isChildOverBudget ? Colors.red : Colors.green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditAccountDialog(account, languageProvider),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.black87,
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddSubAccountDialog(account, languageProvider),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Sub'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return value.toStringAsFixed(0);
  }

  void _showAddAccountDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Account'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Account Code',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 1000',
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'main', child: Text('Main Account')),
                  DropdownMenuItem(value: 'sub', child: Text('Sub-account')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Expected Amount',
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
              // TODO: Implement add account
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }

  void _showEditAccountDialog(Map<String, dynamic> account, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Account - ${account['code']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: account['name']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Expected Amount',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                controller: TextEditingController(text: account['expected'].toString()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Actual Amount',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                controller: TextEditingController(text: account['actual'].toString()),
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
              // TODO: Implement edit account
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }

  void _showAddSubAccountDialog(Map<String, dynamic> parentAccount, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Sub-account to ${parentAccount['code']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Sub-account Code',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 1001',
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Sub-account Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Expected Amount',
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
              // TODO: Implement add sub-account
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }

  void _showAddCollectionDialog(LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Collection Account'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Collection Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Purpose',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Monthly Amount',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
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
              // TODO: Implement add collection
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF97316),
              foregroundColor: Colors.white,
            ),
            child: Text(languageProvider.save),
          ),
        ],
      ),
    );
  }
}