import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../models/consumption.dart';
import '../services/api_service.dart';

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  List<ConsumptionReading> _readings = [];
  bool _isLoading = true;
  String? _selectedCondominium;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReadings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReadings() async {
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

      final readings = await _apiService.getConsumptionReadings(condominiumFilter);
      
      setState(() {
        _readings = readings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading readings: $e'),
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
            title: const Text('Consumption Management'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.camera_alt),
                  text: 'Take Reading',
                ),
                Tab(
                  icon: Icon(Icons.history),
                  text: 'History',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildTakeReadingTab(),
              _buildHistoryTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTakeReadingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Record New Reading',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select the type of meter and take a photo of the reading.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Quick action cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildMeterTypeCard(
                icon: Icons.water_drop,
                title: 'Water Meter',
                color: Colors.blue,
                meterType: 'water',
              ),
              _buildMeterTypeCard(
                icon: Icons.flash_on,
                title: 'Electricity Meter',
                color: Colors.orange,
                meterType: 'electricity',
              ),
              _buildMeterTypeCard(
                icon: Icons.local_gas_station,
                title: 'Gas Meter',
                color: Colors.green,
                meterType: 'gas',
              ),
              _buildMeterTypeCard(
                icon: Icons.thermostat,
                title: 'Other Meter',
                color: Colors.purple,
                meterType: 'other',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeterTypeCard({
    required IconData icon,
    required String title,
    required Color color,
    required String meterType,
  }) {
    return Card(
      child: InkWell(
        onTap: () => _showTakeReadingDialog(meterType, title),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      children: [
        // Filter section
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.user;
            if (user == null || user.isCaretaker) return const SizedBox();

            return Padding(
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
                  _loadReadings();
                },
              ),
            );
          },
        ),

        // Readings list
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _readings.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No readings found',
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
                      itemCount: _readings.length,
                      itemBuilder: (context, index) {
                        final reading = _readings[index];
                        return _buildReadingCard(reading);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildReadingCard(ConsumptionReading reading) {
    IconData icon;
    Color color;
    switch (reading.meterType) {
      case 'water':
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'electricity':
        icon = Icons.flash_on;
        color = Colors.orange;
        break;
      case 'gas':
        icon = Icons.local_gas_station;
        color = Colors.green;
        break;
      default:
        icon = Icons.thermostat;
        color = Colors.purple;
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
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${reading.meterType.toUpperCase()} - ${reading.unit}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  reading.reading.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.apartment, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(reading.condominium, style: const TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${reading.readingDate.day}/${reading.readingDate.month}/${reading.readingDate.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (reading.notes != null) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${reading.notes}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Read by: ${reading.readBy}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                if (reading.photos?.isNotEmpty == true)
                  TextButton.icon(
                    onPressed: () => _showPhotos(reading.photos!),
                    icon: const Icon(Icons.photo, size: 16),
                    label: Text('${reading.photos!.length} photo(s)'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTakeReadingDialog(String meterType, String title) {
    showDialog(
      context: context,
      builder: (context) => TakeReadingDialog(
        meterType: meterType,
        title: title,
        onReadingAdded: _loadReadings,
      ),
    );
  }

  void _showPhotos(List<String> photoUrls) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: Column(
            children: [
              AppBar(
                title: const Text('Reading Photos'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: photoUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      photoUrls[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error),
                        );
                      },
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

class TakeReadingDialog extends StatefulWidget {
  final String meterType;
  final String title;
  final VoidCallback onReadingAdded;

  const TakeReadingDialog({
    super.key,
    required this.meterType,
    required this.title,
    required this.onReadingAdded,
  });

  @override
  State<TakeReadingDialog> createState() => _TakeReadingDialogState();
}

class _TakeReadingDialogState extends State<TakeReadingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _readingController = TextEditingController();
  final _unitController = TextEditingController();
  final _notesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<File> _photos = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox();

        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              children: [
                AppBar(
                  title: Text('Record ${widget.title}'),
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
                          if (user.isCaretaker)
                            Text(
                              'Building: ${user.condominium}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          
                          if (user.isManager) ...[
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Select Condominium',
                              ),
                              items: authProvider.getAccessibleCondominiums().map(
                                (condo) => DropdownMenuItem<String>(
                                  value: condo,
                                  child: Text(condo),
                                ),
                              ).toList(),
                              onChanged: (value) {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a condominium';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          TextFormField(
                            controller: _unitController,
                            decoration: const InputDecoration(
                              labelText: 'Unit/Apartment',
                              hintText: 'e.g., Apt 101',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the unit';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _readingController,
                            decoration: const InputDecoration(
                              labelText: 'Meter Reading',
                              hintText: 'Enter the current reading',
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the reading';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                              labelText: 'Notes (Optional)',
                              hintText: 'Any observations or issues...',
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
                                onPressed: _takePicture,
                                icon: const Icon(Icons.camera_alt, size: 16),
                                label: const Text('Take Photo'),
                              ),
                            ],
                          ),
                          if (_photos.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _photos.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            _photos[index],
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
                                                _photos.removeAt(index);
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
                          onPressed: _submitReading,
                          child: const Text('Save Reading'),
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

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  void _submitReading() {
    if (_formKey.currentState!.validate()) {
      // TODO: Submit reading to API
      Navigator.pop(context);
      widget.onReadingAdded();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reading recorded successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _readingController.dispose();
    _unitController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}