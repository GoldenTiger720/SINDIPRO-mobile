import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'equipment_screen.dart';
import 'consumption_screen.dart';
import 'financial_screen.dart';
import 'calendar_screen.dart';
import 'contacts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox();

        // Define screens based on user role
        final List<Widget> screens = [
          const DashboardScreen(),
          const EquipmentScreen(),
          const ConsumptionScreen(),
          if (user.isManager) const FinancialScreen(),
          const CalendarScreen(),
          const ContactsScreen(),
        ];

        final List<BottomNavigationBarItem> navItems = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Equipment',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Consumption',
          ),
          if (user.isManager) 
            const BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Financial',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF2563EB),
            unselectedItemColor: Colors.grey,
            items: navItems,
          ),
        );
      },
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        if (user == null) return const SizedBox();

        return Scaffold(
          appBar: AppBar(
            title: Text('Dashboard - ${user.role.toUpperCase()}'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    authProvider.logout();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF2563EB),
                              child: Text(
                                user.email[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome, ${user.username ?? user.email}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    user.isManager 
                                        ? 'Manager - All Buildings Access'
                                        : 'Caretaker - ${user.condominium}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildQuickActionCard(
                      icon: Icons.camera_alt,
                      title: 'Take Reading',
                      subtitle: 'Record meter readings',
                      onTap: () {
                        // Navigate to consumption reading
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.build,
                      title: 'Report Issue',
                      subtitle: 'Equipment problems',
                      onTap: () {
                        // Navigate to equipment issues
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.list_alt,
                      title: 'Materials List',
                      subtitle: 'Manage supplies',
                      onTap: () {
                        // Navigate to materials
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.calendar_today,
                      title: 'Schedule',
                      subtitle: 'View appointments',
                      onTap: () {
                        // Navigate to calendar
                      },
                    ),
                    if (user.isManager) ...[
                      _buildQuickActionCard(
                        icon: Icons.attach_money,
                        title: 'Budget',
                        subtitle: 'Maintenance budget',
                        onTap: () {
                          // Navigate to financial
                        },
                      ),
                      _buildQuickActionCard(
                        icon: Icons.analytics,
                        title: 'Reports',
                        subtitle: 'View analytics',
                        onTap: () {
                          // Navigate to reports
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}