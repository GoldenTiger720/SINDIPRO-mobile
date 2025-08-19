import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
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
    return Consumer2<AuthProvider, LanguageProvider>(
      builder: (context, authProvider, languageProvider, child) {
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
                    _buildHeader(context, authProvider, languageProvider),
                    
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

  Widget _buildHeader(BuildContext context, AuthProvider authProvider, LanguageProvider languageProvider) {
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
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    languageProvider.changeLanguage(value);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          languageProvider.currentLocale.languageCode.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'pt',
                      child: Row(
                        children: [
                          const Icon(Icons.flag),
                          const SizedBox(width: 8),
                          Text(languageProvider.portuguese),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'en',
                      child: Row(
                        children: [
                          const Icon(Icons.flag),
                          const SizedBox(width: 8),
                          Text(languageProvider.english),
                        ],
                      ),
                    ),
                  ],
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
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline),
                          const SizedBox(width: 8),
                          Text(languageProvider.myProfile),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings_outlined),
                          const SizedBox(width: 8),
                          Text(languageProvider.settings),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text(languageProvider.logout),
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
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    final dashboardItems = [
      {
        'title': languageProvider.buildingManagement,
        'icon': Icons.apartment,
        'color': const Color(0xFF6B7280), // dashboard-gray
        'route': () => _navigateToScreen(context, const BuildingsScreen()),
      },
      {
        'title': languageProvider.legalObligationsDocuments,
        'icon': Icons.warning,
        'color': const Color(0xFFDC2626), // dashboard-red
        'route': () => _navigateToScreen(context, const LegalObligationsScreen()),
      },
      {
        'title': languageProvider.equipmentMaintenance,
        'icon': Icons.build,
        'color': const Color(0xFF16A34A), // dashboard-green
        'route': () => _navigateToScreen(context, const EquipmentScreen()),
      },
      {
        'title': languageProvider.financialManagement,
        'icon': Icons.bar_chart,
        'color': const Color(0xFFF97316), // dashboard-orange
        'route': () => _navigateToScreen(context, const FinancialScreen()),
      },
      {
        'title': languageProvider.consumptionManagement,
        'icon': Icons.calculate,
        'color': const Color(0xFF2563EB), // dashboard-blue
        'route': () => _navigateToScreen(context, const ConsumptionScreen()),
      },
      {
        'title': languageProvider.fieldManagementSurveys,
        'icon': Icons.chat_bubble_outline,
        'color': const Color(0xFF9333EA), // dashboard-purple
        'route': () => _navigateToScreen(context, const FieldManagementScreen()),
      },
      {
        'title': languageProvider.reports,
        'icon': Icons.description,
        'color': const Color(0xFF0D9488), // dashboard-teal
        'route': () => _navigateToScreen(context, const ReportsScreen()),
      },
      {
        'title': languageProvider.userManagement,
        'icon': Icons.people,
        'color': const Color(0xFFDB2777), // dashboard-pink
        'route': () => _navigateToScreen(context, const UsersScreen()),
      },
      {
        'title': languageProvider.supplierContacts,
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