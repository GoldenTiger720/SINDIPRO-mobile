import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class SupplierContactsScreen extends StatefulWidget {
  const SupplierContactsScreen({super.key});

  @override
  State<SupplierContactsScreen> createState() => _SupplierContactsScreenState();
}

class _SupplierContactsScreenState extends State<SupplierContactsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            const Icon(Icons.calendar_today, color: Color(0xFF4F46E5)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                languageProvider.supplierContacts,
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
          labelColor: const Color(0xFF4F46E5),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4F46E5),
          tabs: [
            Tab(
              icon: const Icon(Icons.calendar_month),
              text: languageProvider.appointmentCalendar,
            ),
            Tab(
              icon: const Icon(Icons.phone),
              text: languageProvider.phoneDirectory,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AppointmentCalendarTab(),
          PhoneDirectoryTab(),
        ],
      ),
    );
      },
    );
  }
}

class AppointmentCalendarTab extends StatelessWidget {
  const AppointmentCalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ações Rápidas',
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
                            _showAddAppointmentDialog(context);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Novo Compromisso'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
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
                            // TODO: Implement calendar view
                          },
                          icon: const Icon(Icons.calendar_view_month),
                          label: const Text('Ver Calendário'),
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
          
          // Today's Appointments
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compromissos de Hoje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final todayAppointments = [
                        {
                          'title': 'Manutenção do Elevador',
                          'supplier': 'ElevaTech Ltda.',
                          'time': '09:00',
                          'duration': '2h',
                          'status': 'confirmed',
                          'type': 'maintenance',
                        },
                        {
                          'title': 'Inspeção do Sistema de Alarme',
                          'supplier': 'SecurMax Segurança',
                          'time': '14:00',
                          'duration': '1h30',
                          'status': 'pending',
                          'type': 'inspection',
                        },
                        {
                          'title': 'Limpeza dos Reservatórios',
                          'supplier': 'AquaClean Serviços',
                          'time': '16:30',
                          'duration': '3h',
                          'status': 'confirmed',
                          'type': 'cleaning',
                        },
                      ];
                      
                      final appointment = todayAppointments[index];
                      return _buildAppointmentTile(appointment, isToday: true);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Upcoming Appointments
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Próximos Compromissos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final upcomingAppointments = [
                        {
                          'title': 'Revisão do Sistema de Portaria',
                          'supplier': 'TechAccess Controle',
                          'date': 'Amanhã',
                          'time': '10:00',
                          'duration': '1h',
                          'status': 'confirmed',
                          'type': 'maintenance',
                        },
                        {
                          'title': 'Manutenção Preventiva - Gerador',
                          'supplier': 'PowerGen Manutenção',
                          'date': '18/12/2024',
                          'time': '08:00',
                          'duration': '4h',
                          'status': 'confirmed',
                          'type': 'maintenance',
                        },
                        {
                          'title': 'Troca de Lâmpadas - Garagem',
                          'supplier': 'IlumiTech Elétrica',
                          'date': '20/12/2024',
                          'time': '13:00',
                          'duration': '2h',
                          'status': 'pending',
                          'type': 'maintenance',
                        },
                        {
                          'title': 'Limpeza de Caixa D\'água',
                          'supplier': 'HidroClean Serviços',
                          'date': '22/12/2024',
                          'time': '07:00',
                          'duration': '6h',
                          'status': 'pending',
                          'type': 'cleaning',
                        },
                      ];
                      
                      final appointment = upcomingAppointments[index];
                      return _buildAppointmentTile(appointment, isToday: false);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Statistics Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estatísticas do Mês',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Agendados',
                          value: '18',
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Concluídos',
                          value: '12',
                          color: const Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Pendentes',
                          value: '6',
                          color: const Color(0xFFF97316),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Cancelados',
                          value: '2',
                          color: const Color(0xFFDC2626),
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

  Widget _buildAppointmentTile(Map<String, dynamic> appointment, {required bool isToday}) {
    Color statusColor;
    String statusText;
    
    switch (appointment['status']) {
      case 'confirmed':
        statusColor = const Color(0xFF16A34A);
        statusText = 'Confirmado';
        break;
      case 'pending':
        statusColor = const Color(0xFFF97316);
        statusText = 'Pendente';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Desconhecido';
    }

    IconData typeIcon;
    switch (appointment['type']) {
      case 'maintenance':
        typeIcon = Icons.build;
        break;
      case 'inspection':
        typeIcon = Icons.search;
        break;
      case 'cleaning':
        typeIcon = Icons.cleaning_services;
        break;
      default:
        typeIcon = Icons.event;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withOpacity(0.1),
        child: Icon(typeIcon, color: statusColor),
      ),
      title: Text(
        appointment['title'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment['supplier']),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                isToday 
                    ? '${appointment['time']} (${appointment['duration']})'
                    : '${appointment['date']} às ${appointment['time']} (${appointment['duration']})',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          statusText,
          style: TextStyle(
            fontSize: 10,
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        // TODO: Show appointment details
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
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
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Compromisso'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Título do Compromisso',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Fornecedor',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'elevatech', child: Text('ElevaTech Ltda.')),
                  DropdownMenuItem(value: 'securmax', child: Text('SecurMax Segurança')),
                  DropdownMenuItem(value: 'aquaclean', child: Text('AquaClean Serviços')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Horário',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Duração Estimada',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Serviço',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'maintenance', child: Text('Manutenção')),
                  DropdownMenuItem(value: 'inspection', child: Text('Inspeção')),
                  DropdownMenuItem(value: 'cleaning', child: Text('Limpeza')),
                  DropdownMenuItem(value: 'repair', child: Text('Reparo')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Create appointment
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }
}

class PhoneDirectoryTab extends StatelessWidget {
  const PhoneDirectoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and Add
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar fornecedor...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAddContactDialog(context);
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Adicionar Contato'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Categories
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categorias',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip('Todos', true),
                      _buildCategoryChip('Manutenção', false),
                      _buildCategoryChip('Limpeza', false),
                      _buildCategoryChip('Segurança', false),
                      _buildCategoryChip('Elétrica', false),
                      _buildCategoryChip('Hidráulica', false),
                      _buildCategoryChip('Jardinagem', false),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Contacts List
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lista de Contatos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final contacts = [
                        {
                          'name': 'ElevaTech Ltda.',
                          'category': 'Manutenção',
                          'phone': '(11) 3456-7890',
                          'email': 'contato@elevatech.com.br',
                          'contact': 'Carlos Silva',
                          'rating': 4.8,
                          'avatar': 'E',
                        },
                        {
                          'name': 'SecurMax Segurança',
                          'category': 'Segurança',
                          'phone': '(11) 9876-5432',
                          'email': 'suporte@securmax.com.br',
                          'contact': 'Ana Santos',
                          'rating': 4.5,
                          'avatar': 'S',
                        },
                        {
                          'name': 'AquaClean Serviços',
                          'category': 'Limpeza',
                          'phone': '(11) 2345-6789',
                          'email': 'aquaclean@gmail.com',
                          'contact': 'João Pedro',
                          'rating': 4.9,
                          'avatar': 'A',
                        },
                        {
                          'name': 'IlumiTech Elétrica',
                          'category': 'Elétrica',
                          'phone': '(11) 8765-4321',
                          'email': 'contato@ilumi.tech',
                          'contact': 'Roberto Lima',
                          'rating': 4.3,
                          'avatar': 'I',
                        },
                        {
                          'name': 'HidroClean Serviços',
                          'category': 'Hidráulica',
                          'phone': '(11) 5432-1098',
                          'email': 'hidro@cleanservicos.com',
                          'contact': 'Marina Costa',
                          'rating': 4.7,
                          'avatar': 'H',
                        },
                        {
                          'name': 'GreenGarden Paisagismo',
                          'category': 'Jardinagem',
                          'phone': '(11) 6789-0123',
                          'email': 'green@garden.com.br',
                          'contact': 'Lucas Oliveira',
                          'rating': 4.6,
                          'avatar': 'G',
                        },
                        {
                          'name': 'PowerGen Manutenção',
                          'category': 'Manutenção',
                          'phone': '(11) 3210-9876',
                          'email': 'power@generation.com',
                          'contact': 'Fernando Rocha',
                          'rating': 4.4,
                          'avatar': 'P',
                        },
                        {
                          'name': 'TechAccess Controle',
                          'category': 'Segurança',
                          'phone': '(11) 4567-8901',
                          'email': 'tech@accesscontrol.com',
                          'contact': 'Patricia Alves',
                          'rating': 4.2,
                          'avatar': 'T',
                        },
                      ];
                      
                      final contact = contacts[index];
                      return _buildContactTile(contact);
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

  Widget _buildCategoryChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement category filtering
      },
      selectedColor: const Color(0xFF4F46E5).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildContactTile(Map<String, dynamic> contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF4F46E5),
        child: Text(
          contact['avatar'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        contact['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${contact['category']} • ${contact['contact']}'),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                contact['phone'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                '${contact['rating']}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          // TODO: Implement contact actions
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'call',
            child: Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text('Ligar'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'email',
            child: Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text('Email'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'schedule',
            child: Row(
              children: [
                Icon(Icons.schedule),
                SizedBox(width: 8),
                Text('Agendar'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Contato'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nome da Empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'maintenance', child: Text('Manutenção')),
                  DropdownMenuItem(value: 'cleaning', child: Text('Limpeza')),
                  DropdownMenuItem(value: 'security', child: Text('Segurança')),
                  DropdownMenuItem(value: 'electrical', child: Text('Elétrica')),
                  DropdownMenuItem(value: 'plumbing', child: Text('Hidráulica')),
                  DropdownMenuItem(value: 'landscaping', child: Text('Jardinagem')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nome do Contato',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Add contact
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}