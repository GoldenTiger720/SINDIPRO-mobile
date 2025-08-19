import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'buildings_screen.dart';
import 'legal_obligations_screen.dart';
import 'equipment_screen.dart';
import 'financial_screen.dart';
import 'consumption_screen.dart';
import 'field_management_screen.dart';
import 'reports_screen.dart';
import 'users_screen.dart';
import 'supplier_contacts_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mobile.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF2563EB).withOpacity(0.8),
                    const Color(0xFF1D4ED8).withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header with logo and user menu
                    _buildHeader(context, authProvider),
                    
                    // Dashboard content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            
                            // Logo
                            Column(
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'SINDI',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'PRO',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDC2626),
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'EXCELÊNCIA EM GESTÃO ',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'DE CONDOMÍNIOS',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFDC2626),
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Dashboard Cards - 2x4 grid matching web version
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.0,
                              children: _buildDashboardCards(context),
                            ),
                            
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button (placeholder for now)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // TODO: Implement hamburger menu
              },
            ),
          ),
          
          // Language selector and user menu
          Row(
            children: [
              // Language selector
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  icon: const Icon(Icons.language, color: Colors.white, size: 18),
                  label: const Text('PT', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    // TODO: Implement language switching
                  },
                ),
              ),
              
              const SizedBox(width: 8),
              
              // User menu
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        // TODO: Navigate to profile
                        break;
                      case 'settings':
                        // TODO: Navigate to settings
                        break;
                      case 'logout':
                        authProvider.logout();
                        break;
                    }
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 8),
                          Text('Meu Perfil'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined),
                          SizedBox(width: 8),
                          Text('Configurações'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Sair'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDashboardCards(BuildContext context) {
    final dashboardItems = [
      {
        'title': 'Cadastro Básico de Condomínios',
        'icon': Icons.apartment,
        'color': const Color(0xFF6B7280), // dashboard-gray
        'route': () => _navigateToScreen(context, const BuildingsScreen()),
      },
      {
        'title': 'Obrigações Legais e Documentos',
        'icon': Icons.warning,
        'color': const Color(0xFFDC2626), // dashboard-red
        'route': () => _navigateToScreen(context, const LegalObligationsScreen()),
      },
      {
        'title': 'Manutenção de Equipamentos',
        'icon': Icons.build,
        'color': const Color(0xFF16A34A), // dashboard-green
        'route': () => _navigateToScreen(context, const EquipmentScreen()),
      },
      {
        'title': 'Gestão Financeira e Orçamentária',
        'icon': Icons.bar_chart,
        'color': const Color(0xFFF97316), // dashboard-orange
        'route': () => _navigateToScreen(context, const FinancialScreen()),
      },
      {
        'title': 'Gestão de Consumo',
        'icon': Icons.calculate,
        'color': const Color(0xFF2563EB), // dashboard-blue
        'route': () => _navigateToScreen(context, const ConsumptionScreen()),
      },
      {
        'title': 'Gestão de Campo e Pesquisas',
        'icon': Icons.chat_bubble_outline,
        'color': const Color(0xFF9333EA), // dashboard-purple
        'route': () => _navigateToScreen(context, const FieldManagementScreen()),
      },
      {
        'title': 'Relatórios',
        'icon': Icons.description,
        'color': const Color(0xFF0D9488), // dashboard-teal
        'route': () => _navigateToScreen(context, const ReportsScreen()),
      },
      {
        'title': 'Gestão de Usuários',
        'icon': Icons.people,
        'color': const Color(0xFFDB2777), // dashboard-pink
        'route': () => _navigateToScreen(context, const UsersScreen()),
      },
      {
        'title': 'Contatos de Fornecedores',
        'icon': Icons.calendar_today,
        'color': const Color(0xFF4F46E5), // dashboard-indigo
        'route': () => _navigateToScreen(context, const SupplierContactsScreen()),
      },
    ];

    return dashboardItems.map((item) => _buildDashboardCard(
      title: item['title'] as String,
      icon: item['icon'] as IconData,
      color: item['color'] as Color,
      onTap: item['route'] as VoidCallback,
    )).toList();
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}