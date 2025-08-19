import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../models/financial.dart';
import '../services/api_service.dart';

class FinancialScreen extends StatefulWidget {
  const FinancialScreen({super.key});

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  MaintenanceBudget? _budget;
  bool _isLoading = true;
  String? _selectedCondominium;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBudgetData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBudgetData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final condominiums = authProvider.getAccessibleCondominiums();
      
      if (condominiums.isNotEmpty) {
        final condominium = _selectedCondominium ?? condominiums.first;
        final budget = await _apiService.getMaintenanceBudget(condominium);
        
        setState(() {
          _budget = budget;
          _selectedCondominium = condominium;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading budget data: $e'),
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
        return Scaffold(
          appBar: AppBar(
            title: const Text('Financial Management'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.dashboard),
                  text: 'Budget Overview',
                ),
                Tab(
                  icon: Icon(Icons.receipt_long),
                  text: 'Expenses',
                ),
              ],
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBudgetOverviewTab(),
                    _buildExpensesTab(),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddExpenseDialog(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBudgetOverviewTab() {
    if (_budget == null) {
      return const Center(
        child: Text('No budget data available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Condominium selector
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return DropdownButtonFormField<String>(
                value: _selectedCondominium,
                decoration: const InputDecoration(
                  labelText: 'Select Condominium',
                  border: OutlineInputBorder(),
                ),
                items: authProvider.getAccessibleCondominiums().map(
                  (condo) => DropdownMenuItem<String>(
                    value: condo,
                    child: Text(condo),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondominium = value;
                  });
                  _loadBudgetData();
                },
              );
            },
          ),
          const SizedBox(height: 24),

          // Budget cards
          Row(
            children: [
              Expanded(
                child: _buildBudgetCard(
                  'Monthly Budget',
                  _budget!.monthlyBudget,
                  _budget!.spentThisMonth,
                  _budget!.remainingMonthly,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBudgetCard(
                  'Yearly Budget',
                  _budget!.yearlyBudget,
                  _budget!.spentThisYear,
                  _budget!.remainingYearly,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Budget usage charts
          const Text(
            'Budget Usage',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Monthly Budget Usage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: _budget!.spentThisMonth,
                            title: 'Spent\nR\$ ${_budget!.spentThisMonth.toStringAsFixed(0)}',
                            color: Colors.red,
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: _budget!.remainingMonthly,
                            title: 'Remaining\nR\$ ${_budget!.remainingMonthly.toStringAsFixed(0)}',
                            color: Colors.blue,
                            radius: 100,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent expenses
          const Text(
            'Recent Expenses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._budget!.expenses.take(5).map((expense) => _buildExpenseCard(expense)),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(
    String title,
    double total,
    double spent,
    double remaining,
    Color color,
  ) {
    final percentage = (spent / total) * 100;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: spent / total,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 80 ? Colors.red : color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spent: R\$ ${spent.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: percentage > 80 ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesTab() {
    if (_budget == null || _budget!.expenses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No expenses recorded yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _budget!.expenses.length,
      itemBuilder: (context, index) {
        final expense = _budget!.expenses[index];
        return _buildExpenseCard(expense);
      },
    );
  }

  Widget _buildExpenseCard(MaintenanceExpense expense) {
    final isInstallment = expense.installments > 1;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    expense.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'R\$ ${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.category, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(expense.category, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${expense.purchaseDate.day}/${expense.purchaseDate.month}/${expense.purchaseDate.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            
            if (isInstallment) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Installment ${expense.currentInstallment}/${expense.installments}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'R\$ ${expense.monthlyInstallmentAmount.toStringAsFixed(2)}/month',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: expense.currentInstallment / expense.installments,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  expense.isFullyPaid ? Colors.green : Colors.blue,
                ),
              ),
            ],
            
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Purchased by: ${expense.purchasedBy}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                if (expense.receipt != null)
                  TextButton.icon(
                    onPressed: () => _showReceipt(expense.receipt!),
                    icon: const Icon(Icons.receipt, size: 16),
                    label: const Text('Receipt'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        condominium: _selectedCondominium!,
        onExpenseAdded: _loadBudgetData,
      ),
    );
  }

  void _showReceipt(String receiptPath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            children: [
              AppBar(
                title: const Text('Receipt'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: Image.network(
                  receiptPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('Failed to load receipt'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddExpenseDialog extends StatefulWidget {
  final String condominium;
  final VoidCallback onExpenseAdded;

  const AddExpenseDialog({
    super.key,
    required this.condominium,
    required this.onExpenseAdded,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _installmentsController = TextEditingController(text: '1');
  String _category = 'Maintenance';
  File? _receiptImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Maintenance',
    'Repairs',
    'Cleaning',
    'Security',
    'Landscaping',
    'Equipment',
    'Utilities',
    'Administrative',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              children: [
                AppBar(
                  title: const Text('Add Expense'),
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
                            'Condominium: ${widget.condominium}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'Describe the expense...',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            value: _category,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                            ),
                            items: _categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _category = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Total Amount',
                              prefixText: 'R\$ ',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _installmentsController,
                            decoration: const InputDecoration(
                              labelText: 'Number of Installments',
                              hintText: 'Enter 1 for single payment',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of installments';
                              }
                              final installments = int.tryParse(value);
                              if (installments == null || installments < 1) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Receipt section
                          Row(
                            children: [
                              const Text(
                                'Receipt:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _pickReceipt,
                                icon: const Icon(Icons.camera_alt, size: 16),
                                label: const Text('Add Receipt'),
                              ),
                            ],
                          ),
                          if (_receiptImage != null) ...[
                            const SizedBox(height: 8),
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _receiptImage!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _receiptImage = null;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                          onPressed: _submitExpense,
                          child: const Text('Add Expense'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickReceipt() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit expense to API
      Navigator.pop(context);
      widget.onExpenseAdded();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense added successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _installmentsController.dispose();
    super.dispose();
  }
}