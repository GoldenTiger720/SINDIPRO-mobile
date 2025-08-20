import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class BuildingsScreen extends StatefulWidget {
  const BuildingsScreen({super.key});

  @override
  State<BuildingsScreen> createState() => _BuildingsScreenState();
}

class _BuildingsScreenState extends State<BuildingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.apartment, color: Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                languageProvider.buildingManagement,
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
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF2563EB),
          tabs: [
            Tab(
              icon: const Icon(Icons.apartment),
              text: languageProvider.buildingInformation,
            ),
            Tab(
              icon: const Icon(Icons.home),
              text: languageProvider.unitManagement,
            ),
            Tab(
              icon: const Icon(Icons.search),
              text: languageProvider.query,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BuildingInformationTab(languageProvider: languageProvider),
          UnitManagementTab(languageProvider: languageProvider),
          UnitQueryTab(languageProvider: languageProvider),
        ],
      ),
    );
      },
    );
  }
}

class BuildingInformationTab extends StatelessWidget {
  final LanguageProvider languageProvider;
  
  const BuildingInformationTab({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações Básicas do Edifício',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Nome do Edifício',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'CNPJ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Edifício',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'residential', child: Text('Residencial')),
                      DropdownMenuItem(value: 'commercial', child: Text('Comercial')),
                      DropdownMenuItem(value: 'mixed', child: Text('Misto')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Total de Unidades',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'CEP',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.number,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.neighborhood,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.city,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.state,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.administratorInfo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: languageProvider.administratorName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: languageProvider.phone,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement save functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(languageProvider.saveInformation),
            ),
          ),
        ],
      ),
    );
  }
}

class UnitManagementTab extends StatelessWidget {
  final LanguageProvider languageProvider;
  
  const UnitManagementTab({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Unit Form
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.addNewUnit,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.unitNumber,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.blockTower,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.floor,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.area,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: languageProvider.owner,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: languageProvider.status,
                      border: const OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'occupied', child: Text('Ocupada')),
                      DropdownMenuItem(value: 'vacant', child: Text('Vaga')),
                      DropdownMenuItem(value: 'maintenance', child: Text('Em Manutenção')),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement add unit functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(languageProvider.addUnit),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Units List
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.registeredUnits,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      labelText: languageProvider.searchUnit,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mock units list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF2563EB),
                          child: Icon(Icons.home, color: Colors.white),
                        ),
                        title: Text('Unidade ${101 + index}'),
                        subtitle: Text('Bloco A - Andar ${index + 1}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: index % 2 == 0 
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                index % 2 == 0 ? 'Ocupada' : 'Vaga',
                                style: TextStyle(
                                  color: index % 2 == 0 
                                      ? Colors.green 
                                      : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Implement edit functionality
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UnitQueryTab extends StatelessWidget {
  final LanguageProvider languageProvider;
  
  const UnitQueryTab({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.consultUnit,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.unitNumber,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: languageProvider.blockTower,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement search functionality
                          },
                          icon: const Icon(Icons.search),
                          label: Text(languageProvider.search),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement clear functionality
                          },
                          icon: const Icon(Icons.clear),
                          label: Text(languageProvider.clear),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Search Results (placeholder)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageProvider.queryResult,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          languageProvider.noQueryPerformed,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          languageProvider.useFieldsAboveToSearch,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
}