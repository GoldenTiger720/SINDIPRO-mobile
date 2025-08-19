import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];
  List<Contact> _allContacts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadContacts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadContacts() {
    // Sample contacts data
    _allContacts = [
      Contact(
        name: 'Emergency Services',
        phone: '193',
        category: 'emergency',
        description: 'Fire Department',
        email: 'bombeiros@emergency.gov.br',
      ),
      Contact(
        name: 'Police',
        phone: '190',
        category: 'emergency',
        description: 'Military Police',
      ),
      Contact(
        name: 'Medical Emergency',
        phone: '192',
        category: 'emergency',
        description: 'SAMU - Emergency Medical Service',
      ),
      Contact(
        name: 'Elevator Maintenance',
        phone: '(11) 9999-1234',
        category: 'maintenance',
        description: 'TechElevator Solutions',
        email: 'contato@techelevator.com.br',
        company: 'TechElevator Solutions',
      ),
      Contact(
        name: 'Plumbing Services',
        phone: '(11) 9999-5678',
        category: 'maintenance',
        description: 'AquaFix Plumbing',
        email: 'atendimento@aquafix.com.br',
        company: 'AquaFix Plumbing',
      ),
      Contact(
        name: 'Electrical Maintenance',
        phone: '(11) 9999-9012',
        category: 'maintenance',
        description: 'ElectroTech Services',
        email: 'servicos@electrotech.com.br',
        company: 'ElectroTech Services',
      ),
      Contact(
        name: 'Security Company',
        phone: '(11) 9999-3456',
        category: 'security',
        description: 'SecureGuard 24h',
        email: 'emergencia@secureguard.com.br',
        company: 'SecureGuard',
      ),
      Contact(
        name: 'Cleaning Services',
        phone: '(11) 9999-7890',
        category: 'services',
        description: 'CleanPro Services',
        email: 'contato@cleanpro.com.br',
        company: 'CleanPro',
      ),
      Contact(
        name: 'Building Manager',
        phone: '(11) 9999-0000',
        category: 'management',
        description: 'João Silva',
        email: 'joao.silva@sindipro.com.br',
      ),
      Contact(
        name: 'Syndicate President',
        phone: '(11) 9999-1111',
        category: 'management',
        description: 'Maria Santos',
        email: 'maria.santos@sindipro.com.br',
      ),
    ];
    _filteredContacts = List.from(_allContacts);
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = List.from(_allContacts);
      } else {
        _filteredContacts = _allContacts
            .where((contact) =>
                contact.name.toLowerCase().contains(query.toLowerCase()) ||
                contact.description.toLowerCase().contains(query.toLowerCase()) ||
                contact.phone.contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Contacts & Phone Directory'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.contacts),
                  text: 'All Contacts',
                ),
                Tab(
                  icon: Icon(Icons.emergency),
                  text: 'Emergency',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAllContactsTab(),
              _buildEmergencyTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddContactDialog,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildAllContactsTab() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search contacts...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _filterContacts,
          ),
        ),

        // Categories
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip('All', null),
              _buildCategoryChip('Emergency', 'emergency'),
              _buildCategoryChip('Maintenance', 'maintenance'),
              _buildCategoryChip('Security', 'security'),
              _buildCategoryChip('Services', 'services'),
              _buildCategoryChip('Management', 'management'),
            ],
          ),
        ),

        // Contacts list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = _filteredContacts[index];
              return _buildContactCard(contact);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyTab() {
    final emergencyContacts = _allContacts
        .where((contact) => contact.category == 'emergency')
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Contacts',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Important emergency numbers for immediate assistance',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView.builder(
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = emergencyContacts[index];
                return _buildEmergencyContactCard(contact);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category) {
    final isSelected = category == null; // For demo, "All" is always selected
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Filter by category
          setState(() {
            if (category == null) {
              _filteredContacts = List.from(_allContacts);
            } else {
              _filteredContacts = _allContacts
                  .where((contact) => contact.category == category)
                  .toList();
            }
          });
        },
      ),
    );
  }

  Widget _buildContactCard(Contact contact) {
    Color categoryColor = _getCategoryColor(contact.category);
    IconData categoryIcon = _getCategoryIcon(contact.category);

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
                  categoryIcon,
                  color: categoryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contact.category.toUpperCase(),
                    style: TextStyle(
                      color: categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contact.description,
              style: const TextStyle(color: Colors.grey),
            ),
            if (contact.company != null) ...[
              const SizedBox(height: 4),
              Text(
                'Company: ${contact.company}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(contact.phone),
                    icon: const Icon(Icons.phone, size: 16),
                    label: Text(contact.phone),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (contact.email != null)
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () => _sendEmail(contact.email!),
                      icon: const Icon(Icons.email, size: 16),
                      label: const Text('Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard(Contact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emergency,
                  color: Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        contact.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _makePhoneCall(contact.phone),
                icon: const Icon(Icons.phone, size: 20),
                label: Text(
                  'CALL ${contact.phone}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'emergency':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      case 'security':
        return Colors.purple;
      case 'services':
        return Colors.blue;
      case 'management':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'emergency':
        return Icons.emergency;
      case 'maintenance':
        return Icons.build;
      case 'security':
        return Icons.security;
      case 'services':
        return Icons.cleaning_services;
      case 'management':
        return Icons.person;
      default:
        return Icons.contact_phone;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch phone dialer'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch email client'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(
        onContactAdded: (contact) {
          setState(() {
            _allContacts.add(contact);
            _filteredContacts = List.from(_allContacts);
          });
        },
      ),
    );
  }
}

class Contact {
  final String name;
  final String phone;
  final String category;
  final String description;
  final String? email;
  final String? company;

  Contact({
    required this.name,
    required this.phone,
    required this.category,
    required this.description,
    this.email,
    this.company,
  });
}

class AddContactDialog extends StatefulWidget {
  final Function(Contact) onContactAdded;

  const AddContactDialog({
    super.key,
    required this.onContactAdded,
  });

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  String _category = 'services';

  final List<String> _categories = [
    'services',
    'maintenance',
    'security',
    'management',
    'emergency',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          children: [
            AppBar(
              title: const Text('Add Contact'),
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
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a contact name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
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
                            child: Text(category.toUpperCase()),
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
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email (Optional)',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _companyController,
                        decoration: const InputDecoration(
                          labelText: 'Company (Optional)',
                        ),
                      ),
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
                      onPressed: _submitContact,
                      child: const Text('Add Contact'),
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

  void _submitContact() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        name: _nameController.text,
        phone: _phoneController.text,
        category: _category,
        description: _descriptionController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        company: _companyController.text.isEmpty ? null : _companyController.text,
      );

      widget.onContactAdded(contact);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact added successfully'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }
}